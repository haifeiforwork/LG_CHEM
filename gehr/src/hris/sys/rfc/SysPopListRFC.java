/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �޴�                                                        */
/*   Program Name : �޴�                                                        */
/*   Program ID   : SysMenuListRFC.java                                         */
/*   Description  : �޴� ��� ��������                                          */
/*   Note         : [���� RFC] : ZHRC_RFC_GET_MENU_LST                          */
/*   Creation     : 2007-04-13  lsa                                             */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.sys.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import java.util.HashMap;

public class SysPopListRFC extends SAPWrap {
    
	private String functionName = "ZGHR_RFC_GET_POPUP_LIST";
    
    /**
     * �ʱ� �˾�
     *
     */
    public HashMap getPopupList(String I_PERNR) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);

            excute(mConnection, function);

            /*
            T_EXPORTA (�������� �� Pop-UP ����)
            T_TEXT (���� �� FAQ ����)
             */
            return getAllExportTable(function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}
