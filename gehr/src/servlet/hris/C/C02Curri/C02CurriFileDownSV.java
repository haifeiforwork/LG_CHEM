package servlet.hris.C.C02Curri;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.C.C02Curri.rfc.C02CurriFileDownRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedOutputStream;
import java.io.BufferedWriter;
import java.io.OutputStreamWriter;
import java.util.Vector;

/**
 * C02CurriFileDownSV.java
 * 교육과정안내 이벤트 유형 정보를 가져오는 Servlet
 *
 * @author 박영락
 * @version 1.0, 2002/01/15
 */
public class C02CurriFileDownSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            WebUserData user = WebUtil.getSessionUser(req);



            res.setContentType("application");

            Box box = WebUtil.getBox(req);
            String PHIO_ID  = box.get("PHIO_ID");
            String STOR_CAT = box.get("STOR_CAT");
            String OBJDES   = box.get("OBJDES");
            String FILE_EXT = box.get("FILE_EXT");

            //처리 후 돌아 갈 페이지
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            //한글 인코딩이 가능한경우
            //OBJDES = new String(OBJDES.getBytes("KSC5601"),"8859_1");

            /*아닌경우*/
            String enCodeOBJDES = WebUtil.encode(OBJDES);
            if( OBJDES.length() != enCodeOBJDES.length() ){
                java.text.SimpleDateFormat formatter  = new java.text.SimpleDateFormat ("yyyyMMddHHmmss");
		        OBJDES = "ESS_"+formatter.format( new java.util.Date());
                Logger.debug.println( this, "DownLoadName : " + OBJDES );
            }
            /*아닌경우*/

            String fname    = OBJDES+"."+FILE_EXT;

            Logger.debug.println(this, PHIO_ID+"   "+STOR_CAT+"   "+OBJDES+"    "+FILE_EXT+"    "+fname);
            C02CurriFileDownRFC fun = new C02CurriFileDownRFC();

            String strClient=req.getHeader("User-Agent");

            //보안조치 1차 개선
            if(strClient.indexOf("MSIE 5.5")>-1) {
                res.setHeader("Content-Disposition", "filename=" + fname.replace("\r","").replace("\n","") + ";");
            } else {
                res.setHeader("Content-Disposition", "attachment;filename=" + fname.replace("\r","").replace("\n","") + ";");
            }
            //res.setHeader("Content-Transfer-Encoding", "binary;");
            //res.setHeader("Pragma", "no-cache;");
            //res.setHeader("Expires", "-1;");

            C02CurriFileDownRFC function = new C02CurriFileDownRFC();
            Vector f_vt = function.getFile(PHIO_ID,STOR_CAT);
            String file_type = (String)f_vt.get(0);

            if( file_type.equals("BINARY") ){
                BufferedOutputStream outs = new BufferedOutputStream(res.getOutputStream());
                for( int i = 1; i < f_vt.size(); i++){
                    byte[] b = (byte[])f_vt.get(i);
                    outs.write(b);
                }
                outs.flush();
                outs.close();
            } else {
                BufferedWriter outs = new BufferedWriter(new OutputStreamWriter((res.getOutputStream())));
                for( int i = 1; i < f_vt.size(); i++){
                    String b = (String)f_vt.get(i);
                    outs.write(b, 0, b.length());
                }
                outs.flush();
                outs.close();
            }

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}

