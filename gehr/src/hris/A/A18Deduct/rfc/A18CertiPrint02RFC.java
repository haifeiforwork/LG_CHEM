package hris.A.A18Deduct.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.A.A18Deduct.* ;

/**
 *  A18CertiPrint02RFC.java
 *  �����ٷμҵ� ������ ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author  �赵��
 * @version 1.0, 2005/09/29
 */
public class A18CertiPrint02RFC extends SAPWrap {

    private String functionName = "ZHRP_RFC_READ_YEA_RESULT_PRIN2" ;

    /**
     * �������� ��������� �������� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param empNo java.lang.String �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public Vector detail( String empNo, String ainf_seqn ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, ainf_seqn);
            excute(mConnection, function);
            
            return getOutput( function );
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
     * @param empNo java.lang.String ���
     * @param ainf_seqn java.lang.String �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String ainf_seqn) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "I_AINF_SEQN";
        setField( function, fieldName2, ainf_seqn ) ;
    }
// Export Return type�� Vector �� ��� �� Vector�� Element type �� com.sns.jdf.util.CodeEntity �� ��� 2
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        Vector ret = new Vector();

//      Table ��ȸ
        String entityName      = "hris.A.A18Deduct.A18CertiPrintBusiData";
        Vector T_BUSINESSPLACE = getTable(entityName,  function, "T_BUSINESSPLACE");
        String entityName2     = "hris.A.A18Deduct.A18CertiPrint02Data";
        Vector T_RESULT        = getTable(entityName2, function, "T_RESULT");

        A18CertiPrintBusiData dataBus = new A18CertiPrintBusiData();
        if( T_BUSINESSPLACE.size() > 0 ) {     dataBus = (A18CertiPrintBusiData)T_BUSINESSPLACE.get(0);     }
        
        ret.addElement(dataBus);
        ret.addElement(T_RESULT);

        return ret;
    }

}