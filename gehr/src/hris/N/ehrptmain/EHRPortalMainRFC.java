package hris.N.ehrptmain;

import java.util.HashMap;
import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.util.DataUtil;

public class EHRPortalMainRFC extends SAPWrap {

    private String functionName = "ZHRA_RFC_EHR_OVERTIME";
    private String functionName1 = "ZHRC_RFC_GET_MENU_LIST2";
    private String functionName2 = "ZHRA_RFC_EHR_INIT_SCREEN2"; 


    /**
     * �ʱ� ȭ�� �ڷḣ RFC�� ȣ���ϴ� Method
     * @param java.lang.String �μ��ڵ�
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getInitViewData( String i_pernr ,String i_orgeh, String i_authorization ) throws GeneralException {
        
        JCO.Client mConnection = null;
        Vector vcRet = new Vector();
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName2) ;

            setField(function ,"I_PERNR"    ,i_pernr);
            setField(function ,"I_ORGEH"    ,i_orgeh);
            setField(function ,"I_AUTHORIZATION" ,i_authorization);
            
            excute(mConnection, function);
            if (getField("E_RETURN" ,function).equals("S")) {
                vcRet.add(getTable("hris.G.G001Approval.ApprovalDocList"    , function ,"T_EXPORTA"));
                vcRet.add(getTable("hris.A.A16Appl.A16ApplListData"         , function ,"T_EXPORTB"));
                vcRet.add(getTable("hris.common.ViewEmpVacationData"        , function ,"T_EXPORTC"));
                vcRet.add(getTable("hris.common.ViewDeptVacationData"       , function ,"T_EXPORTD"));
            } else {
                throw new GeneralException(getField("E_MESSAGE" ,function));
            } // end if
            return vcRet;
        } catch (Exception ex) {
            Logger.sap.println(this, "SAPException ");
            throw new GeneralException(ex.getMessage());
        } finally {
            close(mConnection);
        }
    } 



    /**
     * �ʱ�ȭ�� �ʰ��ٹ����� Method 
     * @param java.lang.String I_PERNR ���
     * @param java.lang.String I_DATUM ���� ��¥
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getOverTime(String sPERNR, String i_orgeh, String i_authorization, String sDate) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setField(function ,"I_PERNR"    , sPERNR);
            setField(function ,"I_ORGEH"    , i_orgeh);
            setField(function ,"I_AUTHORIZATION" , i_authorization);
            setField(function ,"I_DATUM" , sDate);
            excute(mConnection, function);
            Vector ret = getOutput(function);
            return ret;
        } catch(Exception ex) {
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     *  Quick Menu  Method 
     *  I_PERNR		     NUMC 	 8 	  ���
     *  I_PERSK 		 CHAR 	 2 	  ��������׷� 
 	 *  I_TITL2 		 CHAR 	 15  ��å 
     * @param java.lang.String I_PERNR ���
     * @param java.lang.String I_DATUM ���� ��¥
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
     public HashMap getQuickMenu(String sPERNR, String sPersk, String sTitle2) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName1) ;
            setInput(function, sPERNR, sPersk , sTitle2);
            excute(mConnection, function);
            HashMap ret = getQuickOutput(function);
            //Logger.debug(ret);
            return ret;
        } catch(Exception ex) {
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
     
    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.N.ehrptmain.OverTimeData";
        String tableName = "T_EXPORT";
        return getTable(entityName, function, tableName);
    }
    
    
    private void setInput(JCO.Function function, String pernr, String persk, String title2 ) throws GeneralException{
        setField(function, "I_PERNR", pernr);
        setField(function, "I_PERSK", persk);
        setField(function, "I_TITL2", title2);
    }
    
    private HashMap getQuickOutput(JCO.Function function) throws GeneralException {
    	HashMap<String, Vector>  qvt = new HashMap<String, Vector>();
        String entityName = "hris.N.ehrptmain.QuickMenuData";
       // String enti
        
        qvt.put("T_PERSK",getTable(entityName   , function ,"T_PERSK"));
        qvt.put("T_TITLE",getTable(entityName  , function ,"T_TITLE"));
        
        return qvt;
    }
    
}

