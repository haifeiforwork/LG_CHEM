/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ����                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : �μ��� �˻�                                                 */
/*   Program ID   : SearchDeptNameRFC                                           */
/*   Description  : �μ��� �˻��ϴ� RFC ����                                    */
/*   Note         : ����                                                        */
/*   Creation     : 2005-02-20 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/


package  hris.D.D12Rotation.rfc;
import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * SearchDeptNameRotRFC
 * ���ѿ� ���� �μ����� �������� RFC�� ȣ���ϴ� Class
 *
 * @author  �����
 * @version 1.0,
 */
public class SearchDeptNameRotRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_ORGNAVI";//ZHRW_RFC_ORGNAVI

    /**
     * ���ѿ� ���� �μ����� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String ����ID, �����ڵ�
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getPernrDeptName(String i_pernr, String i_objtxt, String i_pernrs) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput1(function,i_pernr, i_objtxt, "",i_pernrs);
            excute(mConnection, function);
            Vector ret = getOutput(function);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    public Vector getDeptName(String i_pernr, String i_objtxt, String i_ename) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_pernr, i_objtxt, i_ename );
            excute(mConnection, function);
            Vector ret = getOutput(function);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    public Vector setDept(String i_pernr, String i_objtxt, String i_ename,Vector p_zhra114) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_pernr, i_objtxt, i_ename,p_zhra114);
            excute(mConnection, function);
            Vector ret = getOutput(function);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_pernr, String i_objtxt, String i_ename  ) throws GeneralException {
        String fieldName  = "I_PERNR";
        setField(function, fieldName, i_pernr);
        String fieldName1 = "I_ENAME";
        setField(function, fieldName1, i_ename);
        String fieldName2 = "I_OTEXT";
        setField(function, fieldName2, i_objtxt);
    }
    private void setInput1(JCO.Function function, String i_pernr, String i_objtxt, String i_ename,String i_pernrs ) throws GeneralException {
        String fieldName  = "I_PERNR";
        setField(function, fieldName, i_pernr);
        String fieldName1 = "I_ENAME";
        setField(function, fieldName1, i_ename);
        String fieldName2 = "I_OTEXT";
        setField(function, fieldName2, i_objtxt);
        String fieldName3  = "I_PERNRS";
        setField(function, fieldName3, i_pernrs);
    }
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_pernr, String i_objtxt, String i_ename,Vector p_zhra114) throws GeneralException {
        String fieldName  = "I_PERNR";
        setField(function, fieldName, i_pernr);
        String fieldName1 = "I_ENAME";
        setField(function, fieldName1, i_ename);
        String fieldName2 = "I_OTEXT";
        setField(function, fieldName2, i_objtxt);
    	setTable(function, "T_EXPORTA", p_zhra114);
    }

    /**
     * RFC ������ Export ���� String �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();

    	// Table ��� ��ȸ
    	String entityName = "hris.D.D12Rotation.D12RotationSearchData";
    	Vector T_EXPORTA   = getTable(entityName,  function, "T_EXPORTA");
    	ret.addElement(T_EXPORTA);

    	return ret;
    }

}


