<%@ page import="java.util.*"%>
<%@page import="com.sap.mw.jco.*"%>
<%@ page contentType="text/html; charset=utf-8" 
	%>

<meta HTTP-EQUIV="refresh" content="2">
<%
//out.println( "OK2");
/*
JCO.Pool pool1 = JCO.getClientPoolManager().getPool("sappool1");
out.println( "maxwaittime : " + pool1.getMaxWaitTime() ); %><br><%
out.println( "sappool1" ); %><br><%
out.println( "getMaxPoolSize : " + pool1.getMaxPoolSize());%><br><%
out.println( "getMaxUsed : " + pool1.getMaxUsed() );%><br><%
out.println( "getCurrentPoolSize : " + pool1.getCurrentPoolSize() );%><br><%
out.println( "getNumUsed : " + pool1.getNumUsed() );%><br><br><br><%
*/
JCO.Pool pool = JCO.getClientPoolManager().getPool("PRODPool");

out.println( "PRODPool" ); %><br><%
out.println( "getMaxPoolSize : " + pool.getMaxPoolSize());%><br><%
out.println( "getMaxUsed : " + pool.getMaxUsed() );%><br><%
out.println( "getCurrentPoolSize : " + pool.getCurrentPoolSize() );%><br><%
out.println( "getNumUsed : " + pool.getNumUsed() );%><br><br><br><%
/*
JCO.Pool pool2 = JCO.getClientPoolManager().getPool("sappool2");

out.println( "sappool2" ); %><br><%
out.println( "getMaxPoolSize : " + pool2.getMaxPoolSize());%><br><%
out.println( "getMaxUsed : " + pool2.getMaxUsed() );%><br><%
out.println( "getCurrentPoolSize : " + pool2.getCurrentPoolSize() );%><br><%
out.println( "getNumUsed : " + pool2.getNumUsed() );%><br><br><br><%

*/


/*

byte[] st = pool1.getStates();

for( int i = 0; i < st.length;  i++ ){
    out.println( "pool"+i + " : " + st.toString() );
}

*/

%>

