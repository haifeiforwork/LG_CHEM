package hris.D.rfc ;

import java.util.Vector;

import com.common.constant.Area;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.util.WebUtil;

/**
 *  D16OTHDDupCheckRFC.java
 *  �ʰ��ٹ�, �ް�, ���ο��� ��û�� �ߺ� üũ�� ���� RFC�� ȣ���Ͽ� �̹� ��û�� ���� �о�´�.
 *
 * @author ��α�
 * @version 1.0, 2003/10/17
 */
public class D16OTHDDupCheckRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_OTHD_DUP_CHECK"; //ZHRW_RFC_OTHD_DUP_CHECK

    /**
     * �ʰ��ٹ��� �ް� ��û�� �ߺ� üũ�� ���� RFC�� ȣ���ϴ� Method
     * @param empNo java.lang.String �����ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCheckList( String empNo, String UPMU_TYPE, Area area ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, UPMU_TYPE);
            excute(mConnection, function);
            Vector ret = new Vector();
            if (UPMU_TYPE.equals("17") || !area.equals( Area.KR)) {         // �ʰ��ٹ� ��û
                ret = getOutput(function);
            } else if (UPMU_TYPE.equals("18")) {  // �ް� ��û
                ret = getOutput2(function);
            } else if ( UPMU_TYPE.equals("02")) { // ���ο��� ��û
                ret = getOutput3(function);
            }
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    public String getCheckField( String empNo, String UPMU_TYPE ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, UPMU_TYPE);
            excute(mConnection, function);

            String fieldName = "E_FLAG" ;

            return getField( fieldName, function ) ;
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
     * @param empNo java.lang.String �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String UPMU_TYPE) throws GeneralException {
        
        setField( function, "I_PERNR", empNo ); //PERNR
        
        setField( function, "I_UPMU_TYPE", UPMU_TYPE ); //UPMU_TYPE
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D16OTHDDupCheckData";
        String tableName  = "T_OTRESULT"; //OTRESULT
        return getTable(entityName, function, tableName);
    }

    private Vector getOutput2(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D16OTHDDupCheckData2";
        String tableName  = "T_HDRESULT";//HDRESULT
        return getTable(entityName, function, tableName);
    }

    private Vector getOutput3(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D16OTHDDupCheckData3";
        String tableName  = "T_PPRESULT";//PPRESULT
        return getTable(entityName, function, tableName);
    }


//    private Object getOutput2(JCO.Function function, D16OTHDDupCheckData2 data2) throws GeneralException {
//        return getFields( data2, function );
//    }
}