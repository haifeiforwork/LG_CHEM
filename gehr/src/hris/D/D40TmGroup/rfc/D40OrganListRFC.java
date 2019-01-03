/********************************************************************************/
/*																											*/
/*   System Name	: MSS																		*/
/*   1Depth Name		: �μ�����																	*/
/*   2Depth Name		: ����                                                           							*/
/*   Program Name	: ������                                   											*/
/*   Program ID		: D40OrganListRFC.java													*/
/*   Description		: ������																		*/
/*   Note				: ����																			*/
/*   Creation  			: 2017-12-08 ������														*/
/*   Update   			: 2017-12-08 ������														*/
/*																											*/
/********************************************************************************/

package hris.D.D40TmGroup.rfc;


import hris.D.D40TmGroup.D40OrganInfoData;

import java.util.Vector;

import com.common.Utils;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * OrganListRFC.java
 * ���ѿ� ���� ��ü ���� List�� �������� RFC�� ȣ���ϴ� Class
 *
 * @author  ������
 * @version 1.0, 2017/12/08
 */
public class D40OrganListRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_TM_GET_ORGEH_LIST";
	//private String functionName = "ZGHR_RFC_GET_ORGEH_LIST";
    /**
     * ���ѿ� ���� ��ü ���� List�� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<D40OrganInfoData> getOrganList(String I_PERNR, String I_AUTHOR, String I_DATUM, String I_SELTAB, Vector T_IMPORTA) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_AUTHOR", I_AUTHOR);
            setField(function, "I_DATUM", I_DATUM);
            setField(function, "I_SELTAB", I_SELTAB);
            //setField(function, "I_IMWON", "");

            if(Utils.getSize(T_IMPORTA) > 0){
                setTable(function, "T_IMPORTA", T_IMPORTA);
            }
            excute(mConnection, function);
            if("B".equals(I_SELTAB)){
            	return getTable(D40OrganInfoData.class,  function, "T_EXPORTB");
            }else if("C".equals(I_SELTAB)){
            	return getTable(D40OrganInfoData.class,  function, "T_EXPORTC");
            }else{
            	return getTable(D40OrganInfoData.class,  function, "T_EXPORTA");
            }

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}


