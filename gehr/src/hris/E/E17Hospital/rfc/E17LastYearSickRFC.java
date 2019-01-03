package hris.E.E17Hospital.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.E.E17Hospital.* ;

/**
 * E17SickRFC.java
 *  ����� �Ƿ�� ��û�� ���� ������ �����Ϸκ��� 1���̳��� �󺴸�(���ܸ�) ����Ʈ�� �������� RFC�� ȣ���ϴ� Class
 *
 * @author lsa
 * @version 1.0, 2009/01/06
 */
public class E17LastYearSickRFC extends SAPWrap {

    private String functionName = "ZHRW_RFC_READ_9406" ;

    private Vector return_vt = null;     // ������ �׸��� ������ȣ�� �ش��ϴ� �󺴸�, ��ü�� ������� ������.
    
    /**
     * ������ �׸��� ������ȣ�� �ش��ϴ� �󺴸�, ��ü�� ������� �����͸� �������� Method
     * @param java.lang.String �����ȣ
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
     * @param java.lang.String �����ȣ
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
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.E.E17Hospital.E17SickData";
        String tableName  = "E_9406";
        return getTable(entityName, function, tableName);
    }
}
