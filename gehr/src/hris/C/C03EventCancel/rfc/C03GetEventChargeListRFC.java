package hris.C.C03EventCancel.rfc;
 
import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.C.C03EventCancel.C03bapiReturnData;

/**
 * C03GetEventChargeListRFC.java
 * ������ҽ�û ����Ϸ�� �̺�Ʈ����ڿ��� �����뺸�� ���� �뺸�ڸ���Ʈ �������� RFC�� ȣ���ϴ� Class
 *
 * @author lsa
 * @version 1.0, 2013/06/14 ������ҽ�û ���� �߰� | [��û��ȣ]C20130627_58399
 */
public class C03GetEventChargeListRFC extends SAPWrap {

    private String functionName = "ZHRD_RFC_SERCH_PERNR_CHARGE";

    /**
     * ������ �ް���û ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    public Vector getChargeList(String chaID ) throws GeneralException {

        JCO.Client mConnection = null;
        Vector vcRet = new Vector(); 

        C03bapiReturnData c03bapiReturnData = new C03bapiReturnData();  // RETURN CODE
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;


            setInput(function, chaID );
            excute(mConnection, function);
 
            Vector ListData = getTable( "hris.C.C03EventCancel.C03GetEventChargeListData", function, "IT_LIST" ); 
            getStructor( c03bapiReturnData, function, "RETURN");

            vcRet.add(ListData);
            vcRet.add(c03bapiReturnData);
            return vcRet;
             
            
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
     * @param value java.lang.String ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String chaID) throws GeneralException {
        String fieldName1 = "IM_CHAID"          ;
        setField(function, fieldName1, chaID); 
    }
 
}
