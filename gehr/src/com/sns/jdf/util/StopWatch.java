/**
  * StopWatch.java
  *
  **/

// PACKAGE
package com.sns.jdf.util;

public class StopWatch 
{
	long start = 0;
	long current = 0;

	public StopWatch() {
		reset();
	}

	public long getElapsed() {
		long now = System.currentTimeMillis();
		long elapsed = (now - current);
		current = now;
		return elapsed;
	}

	public long getTotalElapsed() {
		current = System.currentTimeMillis();
		return (current-start) ;
	}
	
	public void reset() {
		start = System.currentTimeMillis();
		current = start;
	}
}

