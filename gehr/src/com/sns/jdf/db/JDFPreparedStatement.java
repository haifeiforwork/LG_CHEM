/**
  * JDFPreparedStatement.java
  *
  **/

// PACKAGE
package com.sns.jdf.db;

import java.sql.*;
import com.sns.jdf.*;
import com.sns.jdf.util.StopWatch;

public class JDFPreparedStatement 
{
	private Object caller = null;
	private String query = null;
	private PreparedStatement pstmt = null;

	public JDFPreparedStatement(Object caller, String s, PreparedStatement pstmt) {
		this.caller = caller;
		this.query = s;
		this.pstmt = pstmt;
	}

	public boolean execute() throws SQLException {
		boolean result = false;
		StopWatch watch = new StopWatch();
		try {
			result = pstmt.execute();
		}
		finally{
			Logger.dbwrap.println(caller, query+":elapsed="+watch.getElapsed());
		}
		return result;
	}

	public ResultSet executeQuery() throws SQLException {
		ResultSet rs = null;
		StopWatch watch = new StopWatch();
		try {
			rs = pstmt.executeQuery();
		}
		finally{
			boolean mode = true;
			try {
				mode = (new Configuration()).getBoolean("com.sns.jdf.logger.dbwrap.select.trace");
			}catch(Exception e){}
			if ( mode ) 
				Logger.dbwrap.println(caller, query+":elapsed="+watch.getElapsed());
		}
		return rs;
	}

	public int executeUpdate() throws SQLException {
		int result = 0;
		StopWatch watch = new StopWatch();
		try {
			result = pstmt.executeUpdate();
		}
		finally{
			Logger.dbwrap.println(caller, query+":elapsed="+watch.getElapsed());
		}

		return result;
	}
}

