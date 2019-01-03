/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 메뉴                                                        */
/*   Program Name : 메뉴                                                        */
/*   Program ID   : SysMenuListRFC.java                                         */
/*   Description  : 메뉴 목록 가져오기                                          */
/*   Note         : [관련 RFC] : ZHRC_RFC_GET_MENU_LST                          */
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
     * 초기 팝업
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
            T_EXPORTA (공지사항 및 Pop-UP 사항)
            T_TEXT (공지 및 FAQ 내용)
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
