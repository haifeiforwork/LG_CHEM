package hris.D.D01OT.rfc;

import java.util.Date;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.util.DataUtil;


/**
 * D01OTCheckRFC.java
 * �ʰ��ٹ� �ش翩�θ� ýũ�ϴ� RFC �� ȣ���ϴ� Class
 *
 * @author �ڿ���
 * @version 1.0, 2002/03/15
 * [CSR ID:3303691]  ���Ľ�û���� �����߰�
 */
public class D01OTCheckGlobalRFC extends SAPWrap {

//    private String functionName = "ZHRW_RFC_OVERTIME_CHECK";
    private String functionName = "ZGHR_RFC_OVERTIME_CHECK";
    //private String functionName1 = "ZHR_WORK_END_DATE_CHECK";
    private String functionName1 = "ZGHR_WORK_END_DATE_CHECK";
    private String functionName2 = "ZGHR_RFC_REQ_DATE_CHECK";  //[CSR ID:3303691] (�ް����Ľ�û ����)
    private String functionName3 = "ZGHR_RFC_APPROVE_END_DAY";  //[CSR ID:3303691] (�ް����Ľ�û ����)
    private String functionName4 = "ZGHR_RFC_OVERTIME_TP_46HOURS"; //2017-04-03 [CSR ID:3340999]   �븸 ������±Ⱓ���� 46�ð� ����


    /**
     * �ʰ��ٹ� ��ȸ RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param java.lang.String �������� �Ϸù�ȣ
     * @param java.lang.String �����ȣ
     * @param java.lang.String �����ȣ
     * @param java.lang.String �����ȣ
     * @param java.lang.String �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public Vector check( String PERSNO, String BEGDA ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, PERSNO, BEGDA);
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

    public String check1( String PERSNO, String BEGDA, String upmu_type ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName1) ;
            setInput1(function, PERSNO, BEGDA, upmu_type);
            excute(mConnection, function);
			//String ret = getField("P_FLAG", function);
            String E_RETURN   = getReturn().MSGTY;
			return E_RETURN;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    //[CSR ID:3303691]  ���Ľ�û���� �����߰� START
    public void check2(HttpServletRequest request, String PERSNO, String BEGDA, String BEGUZ, String  UPMU_TYPE, String AWART ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName2) ;

            setInput2 ( function, PERSNO,  BEGDA,  BEGUZ,  UPMU_TYPE,  AWART,DataUtil.getCurrentDate(request),DataUtil.getCurrentDateTime(request));
            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    //[CSR ID:3303691] ���Ľ�û���� �����߰� END

    //[CSR ID:3303691]  ����Ⱓ���� �����߰� START
    public Vector checkApprovalPeriod(HttpServletRequest request,  String PERSNO, String GTYPE, String BEGDA, String  UPMU_TYPE, String AWART ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName3) ;

            setInput3 ( function, PERSNO, GTYPE,  BEGDA,  UPMU_TYPE,  AWART,DataUtil.getCurrentDate(request));
            excute(mConnection, function);
            return getAapprovalOutput(function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    //[CSR ID:3303691] ����Ⱓ���� �����߰� END

    //2017-04-03 [CSR ID:3340999]  �븸 ������±Ⱓ���� 46�ð� ���� start
    public String checkOvertimeTp46Hours(HttpServletRequest request, String PERSNO, String GTYPE, String AINF_SEQ, String BEGDA, String HOURS ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName4) ;

            setInputOvertimeTp46Hours ( function, PERSNO,  GTYPE, AINF_SEQ, BEGDA,  HOURS);
            excute(mConnection, function);

            return getOutputTp46Hours(function);

        } catch(Exception ex){
            Logger.debug.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
  //2017-04-03 [CSR ID:3340999]  �븸 ������±Ⱓ���� 46�ð� ���� end
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
	 * @param java.lang.String �����ȣ
     * @param java.lang.String �������� �Ϸù�ȣ
     * @param job java.lang.String �������
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String PERSNO, String BEGDA ) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, PERSNO );
        String fieldName2 = "I_BEGDA";
        setField( function, fieldName2, BEGDA );
        /*String fieldName3 = "I_ENDDA";
        setField( function, fieldName3, ENDDA );
        String fieldName4 = "I_BEGUZ";
        setField( function, fieldName4, BEGTI );
        String fieldName5 = "I_ENDUZ";
        setField( function, fieldName5, ENDTI );*/

    }
    private void setInput1(JCO.Function function, String PERSNO, String BEGDA ,String upmu_type) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, PERSNO );
        String fieldName2 = "I_BEGDA";
        setField( function, fieldName2, BEGDA );
        String fieldName3 = "I_UPMU_TYPE";
        setField( function, fieldName3, upmu_type );    // �ʰ��ٹ� ����Ÿ��


    }
    //[CSR ID:3303691] ���Ľ�û���� �����߰� START

    private void setInput2 (JCO.Function function, String PERSNO, String BEGDA, String BEGUZ, String UPMU_TYPE, String AWART, String DATUM, String UZEIT  ) throws GeneralException {
        setField( function,  "I_PERNR",  PERSNO );
        setField( function,  "I_BEGDA",  BEGDA );
        setField( function,  "I_BEGUZ",  BEGUZ );
        setField( function,  "I_UPMU_TYPE",  UPMU_TYPE );
        setField( function,  "I_AWART",  AWART );
        setField( function,  "I_DATUM",  DATUM );
        setField( function,  "I_UZEIT",  UZEIT );
    }
    //[CSR ID:3303691]  ���Ľ�û���� �����߰� END


    //[CSR ID:3303691] ����Ⱓ���� �����߰� START

    private void setInput3 (JCO.Function function, String PERSNO, String GTYPE, String BEGDA,  String UPMU_TYPE, String AWART, String DATUM  ) throws GeneralException {
        setField( function,  "I_PERNR",  PERSNO );
        setField( function,  "I_GTYPE",  GTYPE );
        setField( function,  "I_BEGDA",  BEGDA );
        setField( function,  "I_UPMU_TYPE",  UPMU_TYPE );
        setField( function,  "I_AWART",  AWART );
        setField( function,  "I_DATUM",  DATUM );

    }
    //[CSR ID:3303691]  ����Ⱓ���� �����߰� END

  //2017-04-03 [CSR ID:3340999] �븸 ������±Ⱓ���� 46�ð� ���� start
    private void setInputOvertimeTp46Hours ( JCO.Function function , String PERSNO,  String GTYPE, String AINF_SEQ ,String BEGDA,  String HOURS) throws GeneralException {
        setField( function,  "I_PERNR",  PERSNO );
        setField( function,  "I_GTYPE",  GTYPE );
        setField( function,  "I_AINF_SEQ",  AINF_SEQ );
        setField( function,  "I_BEGDA",  BEGDA );
        setField( function,  "I_HOURS",  HOURS );

    }
    //2017-04-03 [CSR ID:3340999] �븸 ������±Ⱓ���� 46�ð� ���� end

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D01OT.D01OTCheckData";
        Vector ret = getTable(entityName, function, "T_ITAB");
        return ret ;
    }

    private Vector getAapprovalOutput(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();
        String E_DAYS  = getField("E_DAYS",  function);  // �Ⱓ����
        String E_ENDDA  = getField("E_ENDDA",  function);  // ���縶����

        ret.addElement(E_DAYS);
        ret.addElement(E_ENDDA);

        return ret;
    }

    private String getOutputTp46Hours(JCO.Function function) throws GeneralException {

        String fieldName = "E_ANZHL";      // RFC Export ������� ����
        return getField(fieldName, function);
   }

}


