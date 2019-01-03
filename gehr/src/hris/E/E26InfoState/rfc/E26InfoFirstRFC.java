package	hris.E.E26InfoState.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E26InfoState.*;

/**
 * E26InfoFirstRFC.java
 * ���Ե������� ����Ʈ�� �������� class
 *
 * @author ������
 * @version 1.0, 2002/01/04
 */
public class E26InfoFirstRFC extends SAPWrap {

    //private String functionName = "ZHRH_RFC_INFORMAL_FIRST";
    private String functionName = "ZGHR_RFC_INFORMAL_FIRST";

    /**
     * ���Ե������� ����Ʈ�� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String�����ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getInfoFirst(String empNo) throws GeneralException {

        JCO.Client mConnection = null;
        try{

            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            setInput(function, empNo);

            excute(mConnection, function);

            Vector ret = getTable(E26InfoStateData.class, function, "T_RESULT");//getOutput(function);

            for ( int i = 0 ; i < ret.size() ; i++ ){
                E26InfoStateData data = (E26InfoStateData)ret.get(i);
                data.BETRG = Double.toString(Double.parseDouble(data.BETRG) * 100.0 );
            }

            //Logger.debug.println(this, "ret"+ret.toString());

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
     * @param function com.sap.mw.jco.JCO.Function java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
   private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName = "I_PERNR"          ;
        setField(function, fieldName, empNo);


    }

}

