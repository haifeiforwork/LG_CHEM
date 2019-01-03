package hris.B.rfc;

import com.sns.jdf.*;
import com.sns.jdf.sap.SAPWrap;
import java.util.Vector;

public class B03DevelopChiefInfoRFC extends SAPWrap
{

    public B03DevelopChiefInfoRFC()
    {
        functionName = "ZHRA_RFC_GET_DEVELOP_CHIEF";
    }

    public Vector getChief(String s, String s1)
        throws GeneralException
    {
        com.sap.mw.jco.JCO.Client client = null;
        try
        {
            client = getClient();
            com.sap.mw.jco.JCO.Function function = createFunction(functionName);
            setInput(function, s, s1);
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
        String s = "hris.B.B03DevelopChiefInfoData";
        String s1 = "CHIEF_INFO";
        return getTable(s, function, s1);
    }

    private void setInput(com.sap.mw.jco.JCO.Function function, String s, String s1)
        throws GeneralException
    {
        String s2 = "L_BUKRS";
        String s3 = "L_COMM_TYPE";
        setField(function, s2, s);
        setField(function, s3, s1);
    }

    private String functionName;
}
