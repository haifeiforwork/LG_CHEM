package hris.E.E17Hospital.rfc ;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.E.E17Hospital.E17SickData;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

/**
 * E17SickRFC.java
 *  ����� �Ƿ�� ��û�� ���� ��/������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �輺��
 * @version 1.0, 2002/01/08
 */
public class E17SickRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_LAST_RECORD" ;

    private String RCPT_NUMB = null;     // �Ƿ���׸� ���� , ������ ������ �����´�
    private Vector<E17SickData> return_vt = null;     // ������ �׸��� ������ȣ�� �ش��ϴ� �󺴸�, ��ü�� ������� ������.


    public String getRCPT_NUMB() {
        return RCPT_NUMB;
    }

    public Vector<E17SickData> getReturn_vt() {
        return return_vt;
    }

    /**
     * ����� �Ƿ�� ��û�� ���� ��/������ �������� RFC ȣ���ϴ� Method
     */
    public void getDetailData(String I_PERNR, String I_GUEN_CODE, String I_OBJPS_21, String I_REGNO) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField( function, "I_PERNR",  I_PERNR );
            setField( function, "I_GUEN_CODE", I_GUEN_CODE );
            setField( function, "I_OBJPS_21", I_OBJPS_21 );
            setField( function, "I_REGNO", I_REGNO );

            excute(mConnection, function);

            Map<String, Object> resultMap = new HashMap();

            RCPT_NUMB = getField("E_RCPT_NUMB", function);
            return_vt =  getTable(E17SickData.class, function, "T_9406");

            /*RCPT_NUMB = null;     // �Ƿ���׸� ���� , ������ ������ �����´�*/
            /*return_vt = null;     // ������ �׸��� ������ȣ�� �ش��ϴ� �󺴸�, ��ü�� ������� ������.*/

        }catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    /**
     * �Ƿ���׸� ���� , ������ ������ �������� Method
     * @param empNo java.lang.String �����ȣ
     * @return java.lang.String �Ƿ���׸� ������ ����
     * @exception com.sns.jdf.GeneralException
     */
    public String getRCPT_NUMB(String empNo, String Guen_code, String Objps_21, String Regno) throws GeneralException {
        if(RCPT_NUMB==null){
            getData(empNo, Guen_code, Objps_21, Regno);
        }
        return RCPT_NUMB;
    }

    /**
     * ������ �׸��� ������ȣ�� �ش��ϴ� �󺴸�, ��ü�� ������� �����͸� �������� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getSickData(String empNo, String Guen_code, String Objps_21, String Regno) throws GeneralException {
        if(return_vt==null){
            getData(empNo, Guen_code, Objps_21, Regno);
        }

        return return_vt;
    }
    /**
     * ����� �Ƿ�� ��û�� ���� ��/������ �������� RFC ȣ���ϴ� Method
     * @return hris.E.E05House.E05PersInfoData
     * @exception com.sns.jdf.GeneralException
     */
    private void getData(String empNo, String Guen_code, String Objps_21, String Regno) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, Guen_code, Objps_21, Regno);
            excute(mConnection, function);
            return_vt = getOutput(function);
            RCPT_NUMB = getRCPT_NUMB(function);
        }catch(Exception ex){
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
    private void setInput(JCO.Function function, String empNo, String Guen_code, String Objps_21, String Regno) throws GeneralException {
        String fieldName  = "I_PERNR";
        setField( function, fieldName,  empNo );
        String fieldName1 = "I_GUEN_CODE";
        setField( function, fieldName1, Guen_code );
        String fieldName2 = "I_OBJPS_21";
        setField( function, fieldName2, Objps_21 );
        String fieldName3 = "I_REGNO";
        setField( function, fieldName3, Regno );
    }

    /**
     * RFC ������ Export ���� String �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private String getRCPT_NUMB(JCO.Function function) throws GeneralException {
        String fieldName = "E_RCPT_NUMB";      // RFC Export ������� ����
        return getField(fieldName, function);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.E.E17Hospital.E17SickData";
        String tableName  = "T_9406";
        return getTable(entityName, function, tableName);
    }
}
