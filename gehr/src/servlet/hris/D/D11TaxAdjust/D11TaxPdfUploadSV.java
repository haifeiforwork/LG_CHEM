/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 인사정보                                              */
/*   2Depth Name  : 급여                                              */
/*   Program Name : 연말정산국세청 자료 Upload (PDF)                                              */
/*   Program ID   : D11TaxPdfUploadSV                                               */
/*   Description  : 연말정산국세청 자료 Upload class                                 */
/*   Note         :                                                             */
/*   Creation     : 2012-01-31  LSA                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.D.D11TaxAdjust;

import java.util.ArrayList;

import javax.servlet.http.*;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;

import hris.common.rfc.*;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
public class D11TaxPdfUploadSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user    = (WebUserData)session.getAttribute("user");
            Box         box     = WebUtil.getBox(req);

            String dest       = "";
            String targetYear = "";
            
            //대리 신청 추가
            String PERNR = box.get("PERNR");
            if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            } // end if

            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            
            Logger.debug.println(this,phonenumdata.toString());
            
    	    String xmlLink =  "/jsp/bt/type01/upload/tmp/"  ; //파일속성정보 xml파일 경로 
    	     
    	    ArrayList list = new ArrayList();        
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    	    DocumentBuilder builder = factory.newDocumentBuilder();
    	    Document doc = builder.parse(xmlLink);
    	    
    	    NodeList nList = doc.getElementsByTagName("file");		    

            for (int i = 0; i < nList.getLength(); i++) {
    	    	Node _n = nList.item(i);
    	    	if (_n.getNodeType() == Node.ELEMENT_NODE) {
    	    		Element _e = (Element)_n;
    	    		Logger.debug.println(this,   getTagValue(_e, "filename"     ));
    		    //	hs.put("filesize" , getTagValue(_e, "filesize"     ));	
    		    //	hs.put("filepath" , getTagValue(_e, "filepath"     ));
    		    //	list.add(hs);	
    	    	}		    	  
    	       // temp.setString("fileName", fileName);
    	      //  temp.setString("fileSize", fileSize);
    	      //  temp.setString("filePath", filePath);
    	      //  temp.setString("fileMaskname", fileMaskname);
    	         
         	}
            hris.D.rfc.D00TaxAdjustPeriodRFC periodRFC           = new hris.D.rfc.D00TaxAdjustPeriodRFC();
            hris.D.D00TaxAdjustPeriodData    taxAdjustPeriodData = new hris.D.D00TaxAdjustPeriodData();
            TaxAdjustFlagData                taxAdjustFlagData   = new TaxAdjustFlagData();

            
            // 연말정산 신청/수정/내역조회/시뮬레이션 가능한 기간인지여부를 세션에 저장
            taxAdjustPeriodData = (hris.D.D00TaxAdjustPeriodData)periodRFC.getPeriod(user.companyCode,PERNR);
            Logger.debug.println(this,taxAdjustPeriodData.toString());


            if(taxAdjustPeriodData.BUKRS!=null && taxAdjustPeriodData.BUKRS!=""){

                // 현재일자 가져오기
                String currentData = DataUtil.getCurrentDate();
                int appl_from = DataUtil.getBetween(currentData, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
                int appl_toxx = DataUtil.getBetween(currentData, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
                int simu_from = DataUtil.getBetween(currentData, DataUtil.removeStructur(taxAdjustPeriodData.SIMU_FROM,"-"));
                int simu_toxx = DataUtil.getBetween(currentData, DataUtil.removeStructur(taxAdjustPeriodData.SIMU_TOXX,"-"));
                int disp_from = DataUtil.getBetween(currentData, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
                int disp_toxx = DataUtil.getBetween(currentData, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));

                // 회계년도
               // taxAdjustFlagData.targetYear = taxAdjustPeriodData.APPL_FROM.substring(0,4);
                taxAdjustFlagData.targetYear = taxAdjustPeriodData.YEA_YEAR;
               

                // 현재일자와 비교
                if(appl_from <= 0 && appl_toxx >= 0){
                    taxAdjustFlagData.canPeriod = true;
                    taxAdjustFlagData.canBuild = true;
                }
                if(simu_from <= 0 && simu_toxx >= 0){
                    taxAdjustFlagData.canPeriod = true;
                    taxAdjustFlagData.canSimul = true;
                }
                if(disp_from <= 0 && disp_toxx >= 0){
                    taxAdjustFlagData.canPeriod = true;
                    taxAdjustFlagData.canDetail = true;
                }
              
                session = req.getSession(true);
                session.setAttribute("taxAdjust",taxAdjustFlagData);

                Logger.debug.println(this, "ok login.. 연말정산 기간 : "+taxAdjustFlagData.toString() );  
            } else {
                session = req.getSession(true);
                session.setAttribute("taxAdjust",new TaxAdjustFlagData());

                Logger.debug.println(this, "ok login.. 연말정산 기간 : "+taxAdjustFlagData.toString() );  
            }
            // 연말정산 신청/수정/내역조회/시뮬레이션 가능한 기간인지여부를 세션에 저장

            
            targetYear = ((TaxAdjustFlagData)session.getAttribute("taxAdjust")).targetYear;

            dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustGuide.jsp";
            //dest = WebUtil.ServletURL+ "hris.D.D11TaxAdjust.D11TaxAdjustPersonSV";
            req.setAttribute( "targetYear", targetYear );
            req.setAttribute( "PERNR", PERNR );
            req.setAttribute("PersonData",phonenumdata);
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }    
    public static String getTagValue(Element element, String tagName) {
		String value = "";
		
		try {
			NodeList nodeList = element.getElementsByTagName(tagName);
    		Element e = (Element)nodeList.item(0);
    		NodeList tagNodeList = e.getChildNodes();
    		
    		if ((Node)tagNodeList.item(0) != null) {
    			value = nvl(((Node)tagNodeList.item(0)).getNodeValue());
    		}
		} catch (Exception e) {
			value = e.toString();
		}
		
		return value;
	}
    public static String nvl(String str) {
		return str == null ? "" : str.trim();
	}
}