

/* this ALWAYS GENERATED file contains the IIDs and CLSIDs */

/* link this file in with the server and any clients */


 /* File created by MIDL compiler version 6.00.0366 */
/* at Mon Nov 12 15:34:31 2007
 */
/* Compiler settings for .\ClientTrack.idl:
    Oicf, W1, Zp8, env=Win32 (32b run)
    protocol : dce , ms_ext, c_ext
    error checks: allocation ref bounds_check enum stub_data 
    VC __declspec() decoration level: 
         __declspec(uuid()), __declspec(selectany), __declspec(novtable)
         DECLSPEC_UUID(), MIDL_INTERFACE()
*/
//@@MIDL_FILE_HEADING(  )

#pragma warning( disable: 4049 )  /* more than 64k source lines */


#ifdef __cplusplus
extern "C"{
#endif 


#include <rpc.h>
#include <rpcndr.h>

#ifdef _MIDL_USE_GUIDDEF_

#ifndef INITGUID
#define INITGUID
#include <guiddef.h>
#undef INITGUID
#else
#include <guiddef.h>
#endif

#define MIDL_DEFINE_GUID(type,name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8) \
        DEFINE_GUID(name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8)

#else // !_MIDL_USE_GUIDDEF_

#ifndef __IID_DEFINED__
#define __IID_DEFINED__

typedef struct _IID
{
    unsigned long x;
    unsigned short s1;
    unsigned short s2;
    unsigned char  c[8];
} IID;

#endif // __IID_DEFINED__

#ifndef CLSID_DEFINED
#define CLSID_DEFINED
typedef IID CLSID;
#endif // CLSID_DEFINED

#define MIDL_DEFINE_GUID(type,name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8) \
        const type name = {l,w1,w2,{b1,b2,b3,b4,b5,b6,b7,b8}}

#endif !_MIDL_USE_GUIDDEF_

MIDL_DEFINE_GUID(IID, LIBID_ClientTrackLib,0x6FD5081B,0x30BB,0x47C2,0x8D,0x21,0x58,0x6C,0xE3,0x23,0x29,0x1C);


MIDL_DEFINE_GUID(IID, DIID__DClientTrack,0x6376F744,0xECE3,0x4B58,0x86,0xE0,0x7E,0xFE,0xD8,0xF6,0xDD,0xD9);


MIDL_DEFINE_GUID(IID, DIID__DClientTrackEvents,0x657E8F93,0xBCA3,0x463C,0x98,0xF6,0x30,0x35,0x90,0x44,0xEC,0xBB);


MIDL_DEFINE_GUID(CLSID, CLSID_ClientTrack,0x794834BD,0x2C77,0x4D7E,0x91,0x89,0x68,0xAA,0x99,0xDC,0x42,0x6B);

#undef MIDL_DEFINE_GUID

#ifdef __cplusplus
}
#endif



