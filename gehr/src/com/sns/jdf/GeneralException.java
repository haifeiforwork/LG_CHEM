package com.sns.jdf;

import java.io.PrintStream;
import java.io.PrintWriter;
import java.rmi.RemoteException;
import java.sql.SQLException;

import javax.ejb.EJBException;
import javax.naming.NamingException;

import com.sns.jdf.util.DataUtil;



public class GeneralException extends Exception implements java.io.Serializable
{
	private String message ;
	private String cause  ; 
    private String action  ;
	//private StackTraceElement[] stackTraceBuffer;
	private String stackTraceBuffer;

	public static final String JNDI_PROBLEMS = "JNDI problem";
	public static final String COMM_FAILURE = "RMI/IIOP problem";
	public static final String EJB_FAILURE = "EJB problem";
	public static final String DB_PROBLEMS = "Database problem";
	public static final String UIF_PROBLEMS = "UIF problem";
	public static final String BUSINESS_PROBLEM ="Business problem";
	public static final String SYS_PROBLEM = "System problem";
	
    public GeneralException( Exception e, String message, String action)
    {
        super();
		this.message=message;
		this.action=action;
        selectCause(e);
	}

	public GeneralException(Exception e)
    {
        super();
        this.message="";
		this.action="";
        selectCause(e);
    }

    /**
     * @param message
     */
    public GeneralException(String message)
    {
        super();
        this.message = message;
    }
    
	public GeneralException(Exception e, String message)
    {
        super();
        this.message=message;
		this.action="";
        selectCause(e);
	}

	public String getMessage()
    {
		return message;
	}

	public String getCauseMessage()
    {
		return cause;
	}

	public String getAction()
    {
		return action;
	}
	
	public String getStackTrace(Throwable e)
    {
		return stackTraceBuffer;
	}
	/*
		public StackTraceElement[] getStackTrace()
    {
		return stackTraceBuffer;
	}*/


	public void printStackTrace(PrintStream ps)
    { 
		synchronized (ps) {
			if (stackTraceBuffer != null) {
				ps.print(cause);
				ps.println(stackTraceBuffer);
			} else {
				super.printStackTrace(ps);
			}
		}
    }

	public void printStackTrace(PrintWriter pw)
    { 
		synchronized (pw) {
			if (stackTraceBuffer != null) {
				pw.print(cause);
				pw.println(stackTraceBuffer);
			} else {
				super.printStackTrace(pw);
			}
		}
    }

    private void selectCause(Exception e)
    {

		if (e instanceof NamingException) {
            //Logger.debug.println("NamingException");
            if(message==null || message.equals("")){
                message = e.getMessage(); 
            }
 		    this.cause = JNDI_PROBLEMS;
 			stackTraceBuffer = DataUtil.getStackTrace(e);
		}  else if (e instanceof SQLException) {
            //Logger.debug.println("SQLException");
            if(message==null || message.equals("")){
                message = e.getMessage(); 
            }
			this.cause = DB_PROBLEMS;
			stackTraceBuffer = DataUtil.getStackTrace(e);
		} else if (e instanceof RemoteException) {
            //Logger.debug.println("RemoteException");
            if(message==null || message.equals("")){
                try{
                    java.util.StringTokenizer st = new java.util.StringTokenizer(e.getMessage(), ":");
                    while(st.hasMoreTokens()){
                        message = st.nextToken();
                    }
                }catch(Exception ex){
                    message = e.getMessage();
                }
            }
			this.cause = COMM_FAILURE;
			stackTraceBuffer = DataUtil.getStackTrace(e);
        } else if (e instanceof BusinessException) {
            //Logger.debug.println("BusinessException");
            if(message==null || message.equals("")){
                message = e.getMessage(); 
            }
			this.cause = BUSINESS_PROBLEM;
			stackTraceBuffer = DataUtil.getStackTrace(e);
/*		} else if (e instanceof BspException) {
            //Logger.debug.println("BspException");
            if(message==null || message.equals("")){
                message = e.getMessage(); 
            }
			this.cause = UIF_PROBLEMS;
			stackTraceBuffer = DataUtil.getStackTrace(e);
*/
        } else if (e instanceof GeneralException) {
            //Logger.debug.println("GeneralException");
            if(cause==null || cause.equals("")){
    		    cause = ((GeneralException)e).getCauseMessage();
            }
            if(message==null || message.equals("")){
                message = ((GeneralException)e).getMessage();
            }
            if(action==null || action.equals("")){
                action = ((GeneralException)e).getAction();
            }
            stackTraceBuffer = DataUtil.getStackTrace(e);
		}else if (e instanceof EJBException){  
            //Logger.debug.println("EJBException");
            if(message==null || message.equals("")){
                message = e.getMessage(); 
            }
            this.cause = EJB_FAILURE;
			stackTraceBuffer = DataUtil.getStackTrace(e);
		} else {
            //Logger.debug.println("ETC Exception");
            if(message==null||message.equals("")){
                message = e.getMessage(); 
            }
            this.cause = e.toString();
			stackTraceBuffer = DataUtil.getStackTrace(e);
		}
	}
    
}