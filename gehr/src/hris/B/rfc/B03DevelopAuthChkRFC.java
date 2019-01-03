package hris.B.rfc;

import com.sns.jdf.*;
import com.sns.jdf.sap.SAPWrap;

public class B03DevelopAuthChkRFC extends SAPWrap
{

    public B03DevelopAuthChkRFC()
    {
        functionName = "ZHRW_RFC_GET_AUTH_CHECK";
    }

    public String getAuth(String s, String s1)
        throws GeneralException
    {
        com.sap.mw.jco.JCO.Client client = null;
        try
        {
            client = getClient();
            com.sap.mw.jco.JCO.Function function = createFunction(functionName);
            setInput(function, s, s1);
            excute(client, function);
            String s3 = null;
            s3 = getOutput(function);
            String s2 = s3;
            return s2;
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

    private String getOutput(com.sap.mw.jco.JCO.Function function)
        throws GeneralException
    {
        String s = "I_AUTH";
        return getField(s, function);
    }

    private void setInput(com.sap.mw.jco.JCO.Function function, String s, String s1)
        throws GeneralException
    {
        String s2 = "I_BUKRS";
        String s3 = "I_PERNR";
        setField(function, s2, s);
        setField(function, s3, s1);
    }

    private String functionName;
}
