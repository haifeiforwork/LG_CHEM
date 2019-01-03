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
import hris.sys.MenuCodeData;
import hris.sys.MenuInputData;
import org.apache.commons.lang.StringUtils;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

public class SysMenuListRFC extends SAPWrap {
    
	private String functionName = "ZGHR_RFC_GET_MENU_LIST";
    
    /**
     * �޴� ��� �������� RFC�� ȣ���ϴ� Method
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
     * MenuMap<TopMenu��, subMenuList> ����
     * TopMenu�� ���� �޴� List ����
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
