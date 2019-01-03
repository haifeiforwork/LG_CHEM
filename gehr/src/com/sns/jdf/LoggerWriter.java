package com.sns.jdf;

import java.io.*;
 
public abstract class LoggerWriter
{

	/**
	 * The PrintWriter Agent for real file logging.
	 * 이 PrintWriter 객체가 실제 파일에 기록을 담당한다.
	 * Logger.sys, Logger.err, Logger.warn, Logger.info, Logger.debug 등
	 * 상이한 Reference를 통해 println() 이 호출되더라도 실제는 하나의 파일에
	 * 기록이 일어나므로 물리적인 파일 기록은 하나의 PrintWriter가 담당할 수 밖에 없다.
	 */
	private static PrintWriter writer = null;

	/**
	 * synchronized lock object
	 */
	private final static Object lock = new Object();
	
	/**
	 *	The name of log file today.
	 */
	private static String today = null;

	
	/**
	 * The indication of new line character is printed.
	 */
	private static boolean newLined = true;


	/**
	 * Log Mode.
	 * SYS : Java Development Framework의 에러 로그.
	 *       개발자는 이 부분에 대하여서는 고려하지 않아도 된다.
	 *       그러나 Framework을 개발하는 사람은 이러한 에러가 발생할 시
	 *       반드시 확인하고 문제가 있으면 잡아 주어야 한다.
	 */
	public final static int SYS = 0;

	/**
	 * Log Mode.
	 * ERR : 비즈니즈 적으로 일어나면 안될 심각한 상황의 에러로그.
	 */
	public final static int ERR = 1;
	
	/**
	 * Log Mode.
	 * WARN :비즈니즈 적으로 일어나면 안되지만 그리  심각하지 않은 상황의 에러로그.
	 *          그러나 반드시 차후에 이러한 상황에 대하여 확인 단계를 거쳐야 할 로그.
	 */
	public final static int WARN = 2;
	
	/**
	 * Log Mode.
	 * INFO : 비즈니즈 적으로 충분히 일어날 수 있으며, 필요에 의해 남겨야 할 로그.
	 */
	public final static int INFO = 3;

	/**
	 * Log Mode.
	 * DEBUG : 개발시에 개발자가 보기 위한 것으로, 혹은 향후 어떤 문제가 생겼을 때,
	 *         모든 로그 TRACE 를 보고자 할 때 남을 수 있는 상황의 로그.
	 */
	public final static int DEBUG = 4;

	/**
	 * Log Mode.
	 * DBWRAP : DEBUG와 유사하지만 대부분의 MIS성 어플리케이션은 SQL문장을 포함하고 있으며
	 *         DB Wrapper를 이용해 구현하곤 한다. 이때 DBWrapper 클래스에서 SQL문장만 Logging을
	 *         남기고 싶을 때가 있을 것이다.
	 */
	public final static int DBWRAP = 5;

	/**
	 * Log Mode.
	 * SAP : DEBUG와 유사하지만 SAP에 접근하여 Logging을 남기고 싶을때 사용
	 */
	public final static int SAP = 6;
	
	private int mode;
	
	/**
	 * Line separator string.  This is the value of the line.separator
	 * property at the moment that the stream was created.
	 */
	private static String lineSeparator = System.getProperty("line.separator");
	

	/**
	 * Create a new LoggerWriter.
	 * @param mode The one of LoggerWriter.ERR, LoggerWriter.ERR, 
	 *                         LoggerWriter.WARN, LoggerWriter.INFO, LoggerWriter.DEBUG
	 */
	public LoggerWriter(int mode) {
		this.mode = mode;
		synchronized ( lock ) {
			checkDate();
		}
	}

	/**
	 * Check log file name.
	 */
	private static void checkDate() {
		String day = com.sns.jdf.util.DateTime.getShortDateString();
		if ( day.equals(today) ) return;
		
		try {
			if ( writer != null ) {
				try { writer.close();} catch(Exception e){}
				writer = null;
			}
			today = day;
			//log 사이즈가 너무 커서 file 쪼개서 저장되도록 수정
			String time = com.sns.jdf.util.DateTime.getShortTimeString();
			String addLogName = "";
			if(Integer.parseInt(time.substring(0, 2)) <12){//12시 이전
				addLogName = "AM";
			}else{
				addLogName = "PM";
			}
			String logname = today +"_"+addLogName+".log" ;
			Config conf = new Configuration();
			String directory = conf.get("com.sns.jdf.logger.dir");
			java.io.File file = new java.io.File(directory, logname);
			String filename = file.getAbsolutePath();
			java.io.FileWriter fw =  new java.io.FileWriter(filename, true);// APPEND MODE
			writer = new PrintWriter(
				new java.io.BufferedWriter(fw), 
				conf.getBoolean("com.sns.jdf.logger.autoflush")  // AUTO Flush
			);
		}
		catch(Exception e){
			writer = new PrintWriter(new BufferedWriter(new OutputStreamWriter(System.out)), true);
			writer.println("Can't open log file : " + e.getMessage());
			writer.println("Log will be printed into System.out");
		}
	}

	public void finalize() {
		try {
			if ( writer != null ) writer.flush();
		}
		catch(Exception e){}
	}

	/** Flush the stream. */
	public void flush() {
		if ( isPrintMode() ) writer.flush();
	}
	/**
	 * Get the pre-defined Object's information.
	 * You must be implement this method.
	 * @return java.lang.String
	 * @param o java.lang.Object
	 */
	protected abstract String getPrefixInfo(Object o);

	/**
	 * @return boolean
	 */
	private boolean isPrintMode() {
		boolean isPrintable = true;
		try {
			Config conf = new Configuration();
			switch ( mode ) {
				case SYS:
					isPrintable = conf.getBoolean("com.sns.jdf.logger.sys.trace");
					break;
				case ERR:
					isPrintable = conf.getBoolean("com.sns.jdf.logger.err.trace");
					break;
				case WARN:
					isPrintable = conf.getBoolean("com.sns.jdf.logger.warn.trace");
					break;
				case INFO:
					isPrintable = conf.getBoolean("com.sns.jdf.logger.info.trace");
					break;
				case DEBUG:
					isPrintable = conf.getBoolean("com.sns.jdf.logger.debug.trace");
					break;
				case DBWRAP:
					isPrintable = conf.getBoolean("com.sns.jdf.logger.dbwrap.trace");
					break;
				case SAP:
					isPrintable = conf.getBoolean("com.sns.jdf.logger.sap.trace");
					break;
			}
		}
		catch(Exception e) {
		}
		return isPrintable;
	}

	/** Print an array of chracters. */
	public void print(char x[]) {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.print(x);
			newLined = false;
	    }
	}

	/** Print a character. */
	public void print(char x) {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.print(x);
			newLined = false;
	    }
	}

	/** Print a double. */
	public void print(double x) {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.print(x);
			newLined = false;
	    }

	}

	/** Print a float. */
	public void print(float x) {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.print(x);
			newLined = false;
	    }
	}

	/** Print an integer. */
	public void print(int x) {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.print(x);
			newLined = false;
	    }
	}

	/** Print a long. */
	public void print(long x) {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.print(x);
			newLined = false;
	    }
	}

	/** Print an object. */
	public void print(Object x) {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.print(x);
			newLined = false;
	    }
	}

	/** 
	 * Print predefined information.
	 * Print the predefined information of Object p, 
	 * and then the string of message Object p.
	 */
	public void print(Object p, Object x) {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.print(getPrefixInfo(p));
			writer.print(x);
			newLined = false;
	    }
	}

	/** Print a String. */
	public void print(String x) {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.print(x);
			newLined = false;
	    }
	}

	/** Print a boolean. */
	public void print(boolean x) {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.print(x);
			newLined = false;
	    }
	}

	/** Finish the line. */
	public void println() {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.println();
			newLined = true;
	    }
	}

	/** Print an array of characters, and then finish the line. */
	public void println(char x[]) {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.println(x);
			newLined = true;
	    }
	}

	/** Print a character, and then finish the line. */
	public void println(char x) {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.println(x);
			newLined = true;
	    }
	}

	/** Print a double, and then finish the line. */
	public void println(double x) {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.println(x);
			newLined = true;
	    }
	}

	/** Print a float, and then finish the line. */
	public void println(float x) {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.println(x);
			newLined = true;
	    }
	}

	/** Print an integer, and then finish the line. */
	public void println(int x) {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.println(x);
			newLined = true;
	    }
	}

	/** Print a long, and then finish the line. */
	public void println(long x) {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.println(x);
			newLined = true;
	    }
	}

	/** Print an Object, and then finish the line. */
	public void println(Object x) {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.println(x);
			newLined = true;
	    }
	}

	/** 
	 * Print predefined information.
	 * Print the predefined information of Object p, 
	 * and then the string of message Object p.
	 */
	public void println(Object p, Object x) {
		if ( ! isPrintMode() ) return;
		synchronized ( lock ) {
			if ( newLined ) printTime();
			writer.print(getPrefixInfo(p));
			writer.println(x);
			newLined = true;
		}
	}

	/** Print a String, and then finish the line. */
	public void println(String x) {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.println(x);
			newLined = true;
	    }
	}

	/** Print a boolean, and then finish the line. */
	public void println(boolean x) {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.println(x);
			newLined = true;
	    }
	}

	/**
	 * print current time
	 */
	private void printTime() {
		checkDate();
		char serverty = ' ';
		switch ( mode ) {
			case SYS:
				serverty = 'S';
				break;
			case ERR:
				serverty = 'E';
				break;
			case WARN:
				serverty = 'W';
				break;
			case INFO:
				serverty = 'I';
				break;
			case DEBUG:
				serverty = 'D';
				break;
			case DBWRAP:
				serverty = 'Q';
				break;
			case SAP:
				serverty = 'R';
				break;
		}
		
		writer.write(serverty + com.sns.jdf.util.DateTime.getShortTimeString()+' ') ;
	}

	/**
	 * Write an array of characters.  This method cannot be inherited from the
	 * Writer class because it must suppress I/O exceptions.
	 */
	public void write(char buf[]) {
	write(buf, 0, buf.length);
	}

	/** Write a portion of an array of characters. */
	public void write(char buf[], int off, int len) {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.write(buf, off, len);
			newLined = false;
	    }
	}

	/*
	 * Exception-catching, synchronized output operations,
	 * which also implement the write() methods of Writer
	 */

	/** Write a single character. */
	public void write(int c) {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.write(c);
			newLined = false;
	    }
	}

	/**
	 * Write a string.  This method cannot be inherited from the Writer class
	 * because it must suppress I/O exceptions.
	 */
	public void write(String s) {
	write(s, 0, s.length());
	}

	/** Write a portion of a string. */
	public void write(String s, int off, int len) {
		if ( ! isPrintMode() ) return;
	    synchronized (lock) {
			if ( newLined ) printTime();
			writer.write(s, off, len);
			newLined = false;
	    }
	}
}
