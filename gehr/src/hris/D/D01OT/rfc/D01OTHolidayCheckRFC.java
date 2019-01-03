package hris.D.D01OT.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D01OTHolidayCheckRFC.java
 * ����, ������ üũ�ϴ� RFC �� ȣ���ϴ� Class
 *
 * @author lsa
 * @version 1.0, 2014-05-13  C20140515_40601
 */
public class D01OTHolidayCheckRFC extends SAPWrap {

	private String functionName = "DAY_ATTRIBUTES_GET";

    /**
     * ����, ������ üũ ��ȸ RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector check( String GUBN, String BEGDA, String ENDDA  ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, GUBN, BEGDA, ENDDA );
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
	 * @param java.lang.String �����ȣ
     * @param java.lang.String �������� �Ϸù�ȣ
     * @param job java.lang.String �������
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String GUBN, String BEGDA, String ENDDA  ) throws GeneralException {
        String fieldName1 = "HOLIDAY_CALENDAR";
        setField( function, fieldName1, GUBN );
        String fieldName2 = "DATE_FROM";
        setField( function, fieldName2, BEGDA );
        String fieldName3 = "DATE_TO";
        setField( function, fieldName3, ENDDA );

    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D01OT.D01OTHolidayCheckData";
        Vector ret = getTable(entityName, function, "DAY_ATTRIBUTES");
        return ret ;
    }
}


