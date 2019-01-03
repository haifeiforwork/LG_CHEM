package com.sns.jdf;

import java.util.*;

public abstract class GeneralConfiguration implements Config
{
	protected static Object lock = new Object();
	protected static Properties props = null;
	protected static long lastModified = 0;

	public GeneralConfiguration() throws ConfigurationException {
		super();
	}

	public String get(String key) {
		return getString(key);
	}

	public boolean getBoolean(String key) {
		boolean value = false;
		try {
			value = (new Boolean(props.getProperty(key))).booleanValue();
		}
		catch(Exception e){
			throw new IllegalArgumentException("Illegal Boolean Key : " + key);
		}
		return value;
	}

	public int getInt(String key) {
		int value = -1;
		try {
			value = Integer.parseInt(props.getProperty(key));
		}
		catch(Exception e){
			throw new IllegalArgumentException("Illegal Integer Key : " + key);
		}
		return value;
	}

	public int getInt(String key, int defaultValue) {
		int value = -1;
		try {
			value = Integer.parseInt(props.getProperty(key));
		}
		catch(Exception e){
			Logger.error(e);
			return defaultValue;
		}
		return value;
	}
	
	public Properties getProperties() {
		return props;
	}

	public String getString(String key) {
		String value = null;
		try {
			String tmp = props.getProperty(key);
			if ( tmp == null ) throw new Exception("value of key(" +key+") is null" );
			value = com.sns.jdf.util.DataUtil.E2K(tmp);
		}
		catch(Exception e){
			Logger.debug.println(com.sns.jdf.util.DataUtil.getStackTrace(e));
			throw new IllegalArgumentException("Illegal String Key : " + key);
		}
		return value;
	}

	public long lastModified() {
		return lastModified;
	}
}
