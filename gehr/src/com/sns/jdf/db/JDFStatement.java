/**
  * SNSStatement.java
  *
  **/

// PACKAGE
package com.sns.jdf.db;

import java.sql.*;
import com.sns.jdf.*;
import com.sns.jdf.util.StopWatch;

public class JDFStatement
{
	private Object caller = null;
	private Statement stmt = null;

	public JDFStatement(Object caller, Statement stmt) {
		this.caller = caller;
		this.stmt = stmt;
	}

	public boolean execute(String s) throws SQLException {
		boolean result = false;
		StopWatch watch = new StopWatch();
		try {
			result = stmt.execute(s);
		}
		finally{
			Logger.dbwrap.println(caller, s+":elapsed="+watch.getElapsed());
		}
		return result;
	}

	public ResultSet executeQuery(String s) throws SQLException {
		ResultSet rs = null;
		StopWatch watch = new StopWatch();
		try {
			rs = stmt.executeQuery(s);
		}
		finally{
			boolean mode = true;
			try {
				mode = (new Configuration()).getBoolean("com.sns.jdf.logger.dbwrap.select.trace");
			}catch(Exception e){}
			if ( mode )
				Logger.dbwrap.println(caller, s+":elapsed="+watch.getElapsed());
		}
		return rs;
	}

	public int executeUpdate(String s) throws SQLException {
		int result = 0;
		StopWatch watch = new StopWatch();
		try {
			result = stmt.executeUpdate(s);
		}
		finally{
			Logger.dbwrap.println(caller, s+":elapsed="+watch.getElapsed());
		}
		return result;
	}
}

