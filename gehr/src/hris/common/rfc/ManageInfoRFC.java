package hris.common.rfc ;
import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
/**
 * ManageInfoRFC.java
 * ������,ȸ�����������/FAQ ���������� ��ȸ RFC�� ȣ���ϴ� Class
 *
 * @author ������
 * @version 1.0, 2013/09/20
 */
public class ManageInfoRFC extends SAPWrap {
    private static String functionName = "ZHRA_RFC_GET_MANAGE_INFO" ; 
    /**
     * ������,ȸ�����������/FAQ ���������� ��ȸ RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */ 
    public Vector getManageInfo(String gubun) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, gubun);		//�������� 01:������ ȸ�� ���� �����, 02:FAQ ���� ������	
            excute(mConnection, function);              Vector ret = getOutput(function);            return ret;
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
    private void setInput(JCO.Function function, String gubun) throws GeneralException {
        String fieldName1 = "I_GUBUN";
        setField( function, fieldName1, gubun );
    }    
    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.common.ManageInfoData";
        String tableName  = "T_EXPORT";
        return getTable(entityName, function, tableName);
    }
}