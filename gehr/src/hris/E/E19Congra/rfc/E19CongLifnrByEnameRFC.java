/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ������                                                      */
/*   Program Name : ������                                                      */
/*   Program ID   : E19CongLifnrByEnameRFC                                      */
/*   Description  : ���� �ش��ϴ� �μ����������� ��������  Class              */
/*   Note         : [���� RFC] : ZHRA_RFC_GET_LIFNR_BY_ENAME                    */
/*   Creation     : 2005-12-07  lsa                                             */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.E.E19Congra.rfc;

import hris.E.E19Congra.E19CongLifnrByEnameData;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sap.mw.jco.*;

public class E19CongLifnrByEnameRFC extends SAPWrap {

    //private String functionName = "ZHRA_RFC_GET_LIFNR_BY_ENAME";
	private String functionName = "ZGHR_RFC_GET_LIFNR_BY_ENAME";

    /**
     * �μ����������� �������� RFC�� ȣ���ϴ� Method
     * @param companyCode java.lang.String ȸ���ڵ�
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getLifnr(String companyCode,  String empName, String BANKN, String SWITCH, String PERNR) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, companyCode, empName,BANKN,SWITCH,PERNR);
            excute(mConnection, function);
            Vector ret = new Vector();
            ret =  getTable(E19CongLifnrByEnameData.class, function, "T_RESULT");

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
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String companyCode, String empName, String BANKN, String SWITCH, String PERNR) throws GeneralException {
        String fieldName = "I_BUKRS";
        setField( function, fieldName, companyCode );
	fieldName = "I_ENAME";
	setField( function, fieldName, empName );
	fieldName = "I_BANKN";
	setField( function, fieldName, BANKN );
	fieldName = "I_SWITCH";     //1.�̸����� ������ȣ ã��, 2.������ȣ�� �̸� ã��
	setField( function, fieldName, SWITCH );
	fieldName = "I_PERNR";     //�α��λ��
	setField( function, fieldName, PERNR );

    }

}
