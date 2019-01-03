package servlet.hris.sample;

import com.common.AjaxResultMap;
import com.google.common.collect.Lists;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by manyjung on 2016-07-13.
 */
public class AjaxSampleSV extends EHRBaseServlet {

    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            performTask(req, res);
        } catch(GeneralException e) {
            throw new GeneralException (e);
        }
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        AjaxResultMap resultVO = AjaxResultMap.getInstance();
        try {
            //����� ó�� �κ� key, value �� addResult ȣ��
            resultVO.addResult("resultList", Lists.asList("a", "b", new String[]{"sample list", "lsit3456"}));

            resultVO.writeJson(res);
        } catch (Exception e) {
            resultVO.setErrorMessage("��ȸ�� �����Ͽ����ϴ�.");
            Logger.error(e);
            throw new GeneralException(e);
        }


    }

}
