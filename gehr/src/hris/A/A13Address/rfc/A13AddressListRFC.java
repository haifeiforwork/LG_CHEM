package	hris.A.A13Address.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.servlet.Box;
import hris.A.A13Address.A13AddressListData;

import java.util.Vector;

/**
 * A13AddressListRFC.java
 * 개인의 주소 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 김도신
 * @version 1.0, 2001/12/26
 */
public class A13AddressListRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_ADDRESS_LIST";

    /**
     * 개인의 주소 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getAddressList(Box box) throws GeneralException {

        JCO.Client mConnection = null;
        Vector<A13AddressListData> resultList = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            /*
            필드ID
            I_PERNR
            I_MOLGA
            I_DATUM
            I_SPRSL
            I_GTYPE
            I_SUBTY
            */
            setFieldForLData(function, box);
            setField(function, "I_GTYPE", "1");
            setField(function, "I_SUBTY", "");
            
            excute(mConnection, function);
            
            resultList = getTable(A13AddressListData.class, function, "T_LIST");
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }

        return resultList;
    }
    
    /**
     * 주소 입력 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */ 
    public void build(Box box, Vector importList) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setFieldForLData(function, box);
            setField(function, "I_GTYPE", "2");
            setField(function, "I_SUBTY", box.get("SUBTY"));
            setTable(function, "T_LIST", importList);

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    public void change(Box box, Vector importList) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setFieldForLData(function, box);
            setField(function, "I_GTYPE", "3");
            setTable(function, "T_LIST", importList);

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    


}