/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ����                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : ������ �˻�                                                 */
/*   Program ID   : OrganListRFC.java                                           */
/*   Description  : ������ �˻��ϴ� RFC ����                                    */
/*   Note         : ����                                                        */
/*   Creation     : 2005-01-20 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.common.rfc;

import com.common.Utils;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.common.OrganInfoData;

import java.util.Vector;


/**
 * OrganListRFC.java
 * ���ѿ� ���� ��ü ���� List�� �������� RFC�� ȣ���ϴ� Class
 *
 * @author  �����
 * @version 1.0, 2005/01/19
 */
public class OrganListRFC extends SAPWrap {

    //private String functionName = "ZHRA_RFC_GET_ORGEH_LIST";
	private String functionName = "ZGHR_RFC_GET_ORGEH_LIST";

    /**
     * ���ѿ� ���� ��ü ���� List�� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<OrganInfoData> getOrganList(String I_PERNR, String I_AUTHOR, Vector T_IMPORTA) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_AUTHOR", I_AUTHOR);

            if(Utils.getSize(T_IMPORTA) > 0)
                setTable(function, "T_IMPORTA", T_IMPORTA);

            excute(mConnection, function);

            return getTable(OrganInfoData.class,  function, "T_EXPORTA");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}


