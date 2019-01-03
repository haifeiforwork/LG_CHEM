// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) lnc radix(10) lradix(10)
// Source File Name:   EncryptionException.java

package com.sns.jdf.mobile;


public class EncryptionException extends Exception
{

            public EncryptionException()
            {
            }

            public EncryptionException(String msg)
            {
/*  55*/        super(msg);
            }

            public EncryptionException(Throwable cause)
            {
/*  63*/        super(cause);
            }

            public EncryptionException(String msg, Throwable cause)
            {
/*  72*/        super(msg, cause);
            }
}
