/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : ����                                                        		*/
/*   Program Name : ����/�ϰ� ���� ����ǥ                                       		*/
/*   Program ID   : F42DeptMonthWorkConditionRFC                                */
/*   Description  : �μ��� ����/�ϰ� ���� ����ǥ ��ȸ�� ���� RFC ����          		*/
/*   Note         : ����                                                        		*/
/*   Creation     : 2005-02-17 �����                                           		*/
/*   Update       : 2018-07-19 ��ȯ�� [Worktime52] ���� RFC ����					*/
/*                                                                              */
/********************************************************************************/

package hris.F.rfc;

import hris.common.WebUserData;

import java.util.*;

import com.common.constant.Area;
import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * F42DeptMonthWorkConditionRFC
 * �μ��� ���� ��ü �μ����� 4���� ���ȭ �� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author  �����
 * @version 1.0
 */
public class F42DeptMonthWorkConditionRFC extends SAPWrap {

//	 private String functionName = "ZHRA_RFC_GET_WORK_CONDUCT";
	 private String functionName = "ZGHR_RFC_GET_WORK_CONDUCT";
	 private String functionNameNtm = "ZGHR_RFC_NTM_GET_WORK_CONDUCT";
	 private String functionName1 = "ZGHR_RFC_GET_MONTH_QUOTA";
	 private String functionName2 = "ZGHR_RFC_GET_MONTH_QUOTA2";

    /**
     * �μ��ڵ忡 ���� ��ü �μ����� ����/�ϰ� ���� ����ǥ ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �μ��ڵ�, ����/�ϰ� ����, ��������.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptMonthWorkCondition( String i_orgeh, String i_today, String i_yyyymm, String i_gubun, String i_lower,SAPType sapType, Area area) throws GeneralException {

        JCO.Client mConnection = null;
        Vector ret = null;
        try{

        	String excuteFunction ="";

        	if (  i_gubun.equals("1")){
        		 if (sapType.isLocal()) excuteFunction = functionNameNtm;
        		 else {
        			 if (area==Area.CN)	 excuteFunction = functionName1;
        			 else  excuteFunction = functionName2;
        		 }

        	}else {
        		if (sapType.isLocal()) excuteFunction = functionNameNtm;
        		else excuteFunction = functionName;
        	}
            mConnection = getClient();
            JCO.Function function = createFunction(excuteFunction) ;
            WebUserData userMolga = new WebUserData();
            userMolga.setArea(area);
            setInput(function, i_orgeh, i_today,i_yyyymm, i_gubun, i_lower,sapType);
            excute(mConnection, function,userMolga);
			ret = getOutput(function, i_gubun,sapType);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        return ret;
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_orgeh, String i_today,String i_yyyymm, String i_gubun, String i_lower,SAPType sapType) throws GeneralException {
        String fieldName  = "I_ORGEH";
        setField(function, fieldName, i_orgeh);

        if (sapType.isLocal()) {
            String fieldName1 = "I_TODAY";
            setField(function, fieldName1, i_today);
        	String fieldName2 = "I_GUBUN";
            setField(function, fieldName2, i_gubun);
        }else{
            String fieldName1 = "I_YYYYMM";
            setField(function, fieldName1, i_yyyymm);
        }
        String fieldName3 = "I_LOWERYN";
        setField(function, fieldName3, i_lower);
    }


    /**
     * RFC ������ Export ���� String �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function, String i_gubun,SAPType sapType) throws GeneralException {
    	Vector ret = new Vector();

    	// Export ���� ��ȸ
    	/*String fieldName1 = "E_RETURN";        // �����ڵ�
    	String E_RETURN   = getField(fieldName1, function) ;

    	String fieldName2 = "E_MESSAGE";      // ���̾�α� �������̽��� ���� �޼����ؽ�Ʈ
    	String E_MESSAGE  = getField(fieldName2, function) ;*/

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);


    	 if (sapType.isLocal()) {
        // Table ��� ��ȸ
    	//1:���� 2:���� ����,
    	    	String fieldName3 = "E_YYYYMON";      // ��ȸ���
    	    	String E_YYYYMON  = getField(fieldName3, function) ;
    	    	ret.addElement(E_YYYYMON);
    		 if( i_gubun.equals("1") ){
    			 	Vector T_EXPORTC = getTable(hris.F.F42DeptMonthWorkConditionData.class,  function, "T_EXPORTC");//����
    			 	ret.addElement(T_EXPORTC);
    		 }else{
    			   String fieldName4 = "E_DAY_CNT";      // ���ڼ�
    			   String E_DAY_CNT  = getField(fieldName4, function) ;
    			   Vector T_EXPORTA = getTable(hris.F.F43DeptDayTitleWorkConditionData.class,  function, "T_EXPORTA");//�ϰ� Ÿ��Ʋ.
    			   Vector T_EXPORTB = getTable(hris.F.F43DeptDayDataWorkConditionData.class,  function, "T_EXPORTB"); //�ϰ� ����Ÿ.
    			   ret.addElement(T_EXPORTA);
    			   ret.addElement(T_EXPORTB);
    			   ret.addElement(E_DAY_CNT);
    		 }
    	}else{

    		if( i_gubun.equals("1") ){
    			Vector T_EXPORTA = getTable(hris.F.Global.F42DeptMonthWorkConditionData.class,  function, "T_EXPORTA");	//����
    			ret.addElement(T_EXPORTA);
    			Vector T_EXPORTB = getTable(hris.F.Global.F42DeptMonthWorkConditionData.class,  function, "T_EXPORTB");//����
    			ret.addElement(T_EXPORTB);
    		} else{
    			Vector T_EXPORTA = getTable(hris.F.Global.F43DeptDayTitleWorkConditionData.class, function, "T_EXPORTA");// �ϰ�
    			Vector T_EXPORTB = getTable(hris.F.Global.F43DeptDayDataWorkConditionData.class, function, "T_EXPORTB");// �ϰ�
    			ret.addElement(T_EXPORTA);
    			ret.addElement(T_EXPORTB);
    		}
    	}

    	return ret;
    }

}


