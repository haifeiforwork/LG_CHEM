package hris.B.rfc;

import com.sns.jdf.*;
import com.sns.jdf.sap.SAPWrap;
import java.util.Vector;

public class B03DevelopSectInfoRFC extends SAPWrap
{

    public B03DevelopSectInfoRFC()
    {
        functionName = "ZHRA_RFC_GET_DEVELOP_SECT_COMM";
    }

    public Vector getComm(String s, String s1, String s2)
        throws GeneralException
    {
        com.sap.mw.jco.JCO.Client client = null;
        try
        {
            client = getClient();
            com.sap.mw.jco.JCO.Function function = createFunction(functionName);
            setInput(function, s, s1, s2);
            excute(client, function);
            Vector vector1 = getOutput(function);
            Vector vector = vector1;
            return vector;
        }
        catch(Exception exception1)
        {
            Logger.sap.println(this, "SAPException : " + exception1.toString());
            throw new GeneralException(exception1);
        }
        finally
        {
            close(client);
        }
    }

    private Vector getOutput(com.sap.mw.jco.JCO.Function function)
        throws GeneralException
    {
        String s = "hris.B.B03DevelopSectInfoData";
        String s1 = "SECT_TAB";
        return getTable(s, function, s1);
    }

    private void setInput(com.sap.mw.jco.JCO.Function function, String s, String s1, String s2)
        throws GeneralException
    {
        String s3 = "I_COMM_TYPE";
        setField(function, s3, s);
        String s4 = "I_PERNR";
        setField(function, s4, s1);
        String s5 = "J_PERNR";
        setField(function, s5, s2);
    }

    private String functionName;
}
