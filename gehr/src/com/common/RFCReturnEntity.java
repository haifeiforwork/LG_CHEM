package com.common;

import com.sns.jdf.EntityData;
import org.apache.commons.lang.StringUtils;

/**
 * RFCÀÇ E_RETURN ÀÇ °ª
 * Created by manyjung on 2016-07-21.
 */
public class RFCReturnEntity extends EntityData {

    public String MSGTY;
    public String MSGTX;

    public boolean isSuccess() {
        return StringUtils.equals(MSGTY, "S") || StringUtils.equals(MSGTY, "N");
    }

    public String getMessage() {
        return MSGTX;
    }
}
