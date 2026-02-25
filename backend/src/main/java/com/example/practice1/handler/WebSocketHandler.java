package com.example.practice1.handler;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.example.practice1.model.Player;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import tools.jackson.databind.ObjectMapper;

@Component
public class WebSocketHandler extends TextWebSocketHandler {

	private final JedisPool jedisPool;
    public WebSocketHandler(JedisPool jedisPool) {
        this.jedisPool = jedisPool;
    }
	
	Map<Long, Set<WebSocketSession>> sessions = new ConcurrentHashMap<>();
	Map<String, Player> playersList = new ConcurrentHashMap<>();
	

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		long tableId = getTableId(session);
		
		sessions.computeIfAbsent(tableId, k -> new HashSet<>()).add(session);
		
	}

	@Override
	public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception {
		long tableId = getTableId(session);
		ObjectMapper objectMapper = new ObjectMapper();
		Player chatMessage = objectMapper.readValue(message.getPayload().toString(), Player.class);
		
		if(chatMessage.getUsername() != null && !chatMessage.getUsername().isEmpty())
		{
			playersList.put(session.getId(), chatMessage);
			try(Jedis jedis = jedisPool.getResource())
			{
				jedis.hset("sessions",session.getId(), chatMessage.getUsername());
				
				jedis.sadd("chat" + getTableId(session) + ":users", chatMessage.getUsername());
				
			}
			
			sendSystemMessage(tableId, chatMessage.getUsername() + " joined the table");
			try(Jedis jedis = jedisPool.getResource())
			{
				String key = "chat:" + tableId + ":messages";
				List<String> history = jedis.lrange(key, 0, -1);
				for(String msgJson : history)
				{
					session.sendMessage(new TextMessage(msgJson));
				}
			}
			
		}
		if(chatMessage.getMessage() != null && !chatMessage.getMessage().isEmpty())
		{
			Player sender  = playersList.get(session.getId());
			if(sender != null)
			{
				chatMessage.setUsername(sender.getUsername());

				

				
			}
			chatMessage.setSessionId(session.getId());
			try(Jedis jedis = jedisPool.getResource()){
				String json = objectMapper.writeValueAsString(chatMessage);
				
				String key = "chat:" + getTableId(session) + ":messages";
				
				jedis.rpush(key, json);
				jedis.ltrim(key, -100, -1);
			}
			
			for(WebSocketSession s : sessions.get(tableId))
			{
				s.sendMessage(new TextMessage(objectMapper.writeValueAsString(chatMessage)));
				
			}
		}
		
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
	    super.afterConnectionClosed(session, status);

	    long tableId = getTableId(session);


	    Set<WebSocketSession> tableSessions = sessions.get(tableId);
	    if (tableSessions != null) {
	        tableSessions.remove(session);
	    }

	    try (Jedis jedis = jedisPool.getResource()) {

	        String username = jedis.hget("sessions", session.getId());

	        if (username != null) {

	            String usersKey = "chat" + tableId + ":users";

	            jedis.srem(usersKey, username);


	            sendSystemMessage(tableId, username + " left the table");

	            if (jedis.scard(usersKey) == 0) {
	                jedis.del("chat:" + tableId + ":messages");
	            }
	        }

	        jedis.hdel("sessions", session.getId());
	    }
	}

	
	
	
	private void sendSystemMessage(long tableId, String text) throws Exception {
	    ObjectMapper objectMapper = new ObjectMapper();

	    Map<String, String> systemMessage = Map.of(
	        "type", "SYSTEM",
	        "message", text
	    );

	    String json = objectMapper.writeValueAsString(systemMessage);

	    for (WebSocketSession s : sessions.getOrDefault(tableId, Set.of())) {
	        s.sendMessage(new TextMessage(json));
	    }
	}
	
	
	
	
	
	
	
	private long getTableId(WebSocketSession session)
	{
		String uri = session.getUri().toString();
		String tableIdExtracted = uri.substring(uri.indexOf("/table/") + 7);
		long tableId = 0;
		
		try {
			tableId = Long.parseLong(tableIdExtracted);
		} catch (Exception e) {

		}
		return tableId;
	}
	

}
