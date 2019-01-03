package com.sns.jdf.servlet;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.util.WebUtil;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public abstract class EHRBaseServlet_m extends JDFBaseServlet {
    
    public static final String GO_HOME = "GO_HOME";
    public static final String GO_LOGIN = "GO_LOGIN";
    public static final String GO_BACK = "GO_BACK";
    public static final String GO_BACK_ALERT = "GO_BACK_ALERT";
    public static final String GO_BACK_POPUP_AUTO = "GO_BACK_POPUP_AUTO";
    public static final String GO_BACK_POPUP = "GO_BACK_POPUP";
    public static final String RELOAD = "RELOAD";
    public static final String RELOAD_ALRET = "RELOAD_ALERT";
    public static final String RELOAD_POPUP_AUTO = "RELOAD_POPUP_AUTO";
    public static final String RELOAD_POPUP = "RELOAD_POPUP";

	  public EHRBaseServlet_m() {
		    super();	
	  }
	
	  protected void performPreTask (HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        //session check & authority check
		    HttpSession session = req.getSession(false);

        if (session == null) {
			      Logger.debug.println(this, "session is null");

            String msg = g.getMessage("MSG.COMMON.0064");
            String url = "top.window.close();";
            req.setAttribute("msg", msg);
            req.setAttribute("url", url);
			      printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");

            return;
            //throw new GeneralException("GOLOGIN");
		    } else {      //임시테스트용 - 세션검사 중지

			      if (isLogin(session)) {
				       Logger.debug.println(this, "EHRBaseServlet_m : islogin = true");
               try{
				           performTask(req, res);
                }catch(GeneralException e){
                   Logger.debug.println(this, "perfromTesk에서 에러발생");
                    throw new GeneralException (e);
        	    	}
			      } else {
				        Logger.debug.println(this, "EHRBaseServlet_m : islogin = false");
 
                String msg = g.getMessage("MSG.COMMON.0064");
                String url = "top.window.close();";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);

                printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");
			      }
		    }   
	  }
	
	  protected abstract void performTask (HttpServletRequest req, HttpServletResponse res) throws GeneralException;

    protected void printExceptionPage (HttpServletRequest req, HttpServletResponse res, Exception e) {
        //PrintWriter out = null;
        // try{
        //    out = res.getWriter();
        //    //res.setContentType("text/html;charset=euc-kr"); ?에러 발생 우려가 있다...
        //} catch (Exception ex) { 
        //    Logger.debug.println("Can not getWriter()"+ex.toString());
        //}

        if (e instanceof com.sns.jdf.ConfigurationException){
            try {
                req.setAttribute( "error", new GeneralException(e) );
                RequestDispatcher dispatcher = getServletContext().getRequestDispatcher( WebUtil.ErrorPage );
                dispatcher.forward(req, res);
            } catch (Exception ex) {
                Logger.debug.println(this, "ErrorPage 오류 :"+ex.toString());
            }
            /*
            out.println("<html><head><title>Error</title></head><body bgcolor=white>");
            out.println("Exception....<br>");
            out.println(e.getMessage()+"<br>");
            if(DebugMessageMode)
            {
               out.println(e.toString()+"<br>");
               e.printStackTrace(out);
            }
            out.println("<a href='javascript:history.back()'>뒤로</a>");
            out.println("</body></html>");
            out.close();
            Logger.debug.println("Configuration에러");
            */

        } else if  (e instanceof GeneralException) {
            
           try {
                //req.setAttribute( "errorMode", ((GeneralException)e).getAction() );
                req.setAttribute( "error", (GeneralException)e);
                RequestDispatcher dispatcher = getServletContext().getRequestDispatcher( WebUtil.ErrorPage );
                dispatcher.forward(req, res);
            } catch (Exception ex) {
                Logger.debug.println(this, "ErrorPage 오류 :"+ex.toString());
            }
        }
    }

	  protected boolean isLogin(HttpSession session) {
		    hris.common.WebUserData user_m  = (hris.common.WebUserData)session.getAttribute("user_m");
        if ( user_m == null ) {
            return false;
        }
        String login_stat = user_m.login_stat;

		    Logger.debug.println(this, "isLogin login_stat : " + login_stat);
	      if ( login_stat == null || !login_stat.equals("Y") ) { return (false);	}
		    else { return (true);	}
       
	  }
/*
*   getContext() method 는 servlet 에서 호출한다
*   
*   ehr.ejbs.SubtypeEJB subtype = new ehr.ejbs.SubtypeEJB();
*   java.util.Vector vt = subtype.getSubtype( webUserId, infty, molga, getContext() );
*
*/

/*
*
*   iPlanet에서만 활성화....
*
    protected com.kivasoft.IContext getContext(){

        return ( ( com.netscape.server.servlet.platformhttp.PlatformServletContext )
            getServletContext() ).getContext();
    }
*/    
}
