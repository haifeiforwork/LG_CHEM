package servlet.hris.J.J03JobCreate;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.J.J01JobMatrix.J01ImageFileNameData;
import hris.J.J01JobMatrix.rfc.J01ImageFileNameRFC;
import hris.J.J03JobCreate.rfc.J03FileDownLoadRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedOutputStream;
import java.util.Vector;

/**
 * J03FileDownLoadSV.java
 * KSEA, Process File을 서버에서 다운로드하는 Servlet
 *
 * @author  김도신
 * @version 1.0, 2003/07/01
 */
public class J03FileDownLoadSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession         session        = req.getSession(false);
            WebUserData         user           = (WebUserData)session.getAttribute("user");

            Box                 box            = WebUtil.getBox(req);

            J01ImageFileNameRFC  rfc_i         = new J01ImageFileNameRFC();
            J03FileDownLoadRFC   rfc           = new J03FileDownLoadRFC();
            J01ImageFileNameData data          = new J01ImageFileNameData();

            Vector              j01Result_vt   = new Vector();
            Vector              ret            = new Vector();

            String              i_idx          = box.get("IMGIDX");
            String              i_objid        = box.get("OBJID");
            String              i_sobid        = box.get("SOBID");

            ret            = rfc_i.getDetail( i_idx, i_objid, i_sobid, "99991231" );
            j01Result_vt   = (Vector)ret.get(0);
            if( j01Result_vt.size() > 0 ) {
                data = (J01ImageFileNameData)j01Result_vt.get(0);
            }

//          File 명이 한글인 경우 - 다운로드 이미지 명을 정해준다.
            String enCodeIMAG_NAME = WebUtil.encode(data.IMAG_NAME);
            String filename        = "";
            if( data.IMAG_NAME.length() != enCodeIMAG_NAME.length() ){
    		        filename = data.TASK_CODE + "_" + DataUtil.removeStructur(data.BEGDA, "-") + ".ppt";
            } else {
    		        filename = data.IMAG_NAME;
            }

            String strClient = req.getHeader("User-Agent");

            //보완조치 1차 개선
            if(strClient.indexOf("MSIE 5.5")>-1) {
                res.setHeader("Content-Disposition", "filename="+ filename.replace("\r","").replace("\n","") +";");
            } else {
                res.setHeader("Content-Disposition", "attachment;filename=" + filename.replace("\r","").replace("\n","") + ";" );
            }

            Vector j03File_vt = rfc.getFile(i_idx, data.IMAG_NAME);

            BufferedOutputStream outs = new BufferedOutputStream(res.getOutputStream());
            for( int i = 1; i < j03File_vt.size(); i++){
                byte[] b = (byte[])j03File_vt.get(i);
                outs.write(b);
            }
            outs.flush();
            outs.close();

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}

