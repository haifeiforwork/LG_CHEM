package hris.D.rfc ;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 *  D16OTHDDupCheckRFC2.java
 *  �ʰ��ٹ�, �ް� ��û �� �ߺ� üũ�� �� ����� ���Ϲ���
 * 
IMPORT				
    �ʵ��				Ÿ��		����	����			���
	PERNR			UMC		8		��� ��ȣ	
	UPMU_TYPE		CHAR		3		��������	
	BEGDA			DATS		8		���� ����		"�ް��ΰ�� �ް� ������, �ʰ��ٹ��� ��� ���� �ٹ� ����"
	ENDDA			DATS		8		���� ����		"�ް��ΰ�� �ް� ������,	�ʰ��ٹ��� ��� ���� �ٹ� ����"
EXPORT				
	�ʵ��				Ÿ��		����	����			���
	E_FLAG			CHAR		1		�ߺ�����		Y:�ߺ�, N:OK
	E_MESSAGE		CHAR		200	�ߺ����� 		�޼���	

 *  
 *  [CSR ID:2595636] �����Ͽ� �ް�&��� ���� ��û ��
 * @author ������
 * @version 1.0, 2014/08/24
 */
public class D16OTHDDupCheckRFC2 extends SAPWrap {

//    private String functionName = "ZHRW_RFC_OTHD_DUP_CHECK2";
	private String functionName = "ZGHR_RFC_OTHD_DUP_CHECK2";

    /**
     * �ʰ��ٹ��� �ް� ��û�� �ߺ� üũ�� ���� RFC�� ȣ���ϴ� Method
     * @param empNo java.lang.String �����ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getChecResult( String empNo, String UPMU_TYPE, String BEGDA, String ENDDA ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, UPMU_TYPE, BEGDA, ENDDA);
            excute(mConnection, function);

            Vector ret = new Vector();
            ret = getOutput(function);
            
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

            setInput(function, empNo, UPMU_TYPE, "", "");
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
    private void setInput(JCO.Function function, String empNo, String UPMU_TYPE, String BEGDA, String ENDDA) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "I_UPMU_TYPE";
        setField( function, fieldName2, UPMU_TYPE );
        String fieldName3 = "I_BEGDA";
        setField( function, fieldName3, BEGDA );
        String fieldName4 = "I_ENDDA";
        setField( function, fieldName4, ENDDA );
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();
		String fieldName = "E_FLAG";
		String E_FLAG     = getField(fieldName, function) ;
//		String fieldName2    = "E_MESSAGE";
//		String E_MESSAGE  = getField(fieldName2, function) ;
		String E_MESSAGE  = getReturn().MSGTX;
		ret.addElement(E_FLAG);
		ret.addElement(E_MESSAGE);
        return ret;
    }


//    private Object getOutput2(JCO.Function function, D16OTHDDupCheckData2 data2) throws GeneralException {
//        return getFields( data2, function );
//    }
}