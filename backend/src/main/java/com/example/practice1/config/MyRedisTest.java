package com.example.practice1.config;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import redis.clients.jedis.*;

@Configuration
public class MyRedisTest {
	
	@Bean
	public JedisPool jedisPool1(
	        @Value("${redis.host}") String host,
	        @Value("${redis.port}") int port) {

	    JedisPoolConfig config = new JedisPoolConfig();
	    config.setMaxTotal(20);
	    config.setMaxIdle(10);
	    config.setMinIdle(2);

	    return new JedisPool(config, host, port);
	}

}
