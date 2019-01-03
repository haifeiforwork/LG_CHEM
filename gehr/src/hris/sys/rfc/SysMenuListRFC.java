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
import hris.sys.MenuCodeData;
import hris.sys.MenuInputData;
import org.apache.commons.lang.StringUtils;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

public class SysMenuListRFC extends SAPWrap {
    
	private String functionName = "ZGHR_RFC_GET_MENU_LIST";
    
    /**
     * 메뉴 목록 가져오는 RFC를 호출하는 Method
     *
     */
    public Vector<MenuCodeData> getMenuList(MenuInputData inputData) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setFields(function, inputData);

            excute(mConnection, function);

            Vector<MenuCodeData> menuList = getTable(MenuCodeData.class, function, "T_MENU");


            return menuList;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    /**
     * MenuMap<TopMenu명, subMenuList> 구성
     * TopMenu별 하위 메뉴 List 구성
     * @param menuList
     * @return
     */
    public Map<String, Vector<MenuCodeData>> getMenuMap(Vector<MenuCodeData> menuList) {
        Map<String, Vector<MenuCodeData>> menuMap = new HashMap<String, Vector<MenuCodeData>>();

        for(MenuCodeData menu : menuList) {
            String parentCode = StringUtils.defaultIfEmpty(menu.getHLFCD(), "ROOT");

            Vector<MenuCodeData> subMenuList = menuMap.get(parentCode);
            if(subMenuList == null) subMenuList = new Vector<MenuCodeData>();

            subMenuList.add(menu);

            menuMap.put(parentCode, subMenuList);
        }

        return menuMap;
    }

}
