

/* this ALWAYS GENERATED file contains the definitions for the interfaces */


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


/* verify that the <rpcndr.h> version is high enough to compile this file*/
#ifndef __REQUIRED_RPCNDR_H_VERSION__
#define __REQUIRED_RPCNDR_H_VERSION__ 440
#endif

#include "rpc.h"
#include "rpcndr.h"

#ifndef __ClientTrackidl_h__
#define __ClientTrackidl_h__

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

/* Forward Declarations */ 

#ifndef ___DClientTrack_FWD_DEFINED__
#define ___DClientTrack_FWD_DEFINED__
typedef interface _DClientTrack _DClientTrack;
#endif 	/* ___DClientTrack_FWD_DEFINED__ */


#ifndef ___DClientTrackEvents_FWD_DEFINED__
#define ___DClientTrackEvents_FWD_DEFINED__
typedef interface _DClientTrackEvents _DClientTrackEvents;
#endif 	/* ___DClientTrackEvents_FWD_DEFINED__ */


#ifndef __ClientTrack_FWD_DEFINED__
#define __ClientTrack_FWD_DEFINED__

#ifdef __cplusplus
typedef class ClientTrack ClientTrack;
#else
typedef struct ClientTrack ClientTrack;
#endif /* __cplusplus */

#endif 	/* __ClientTrack_FWD_DEFINED__ */


#ifdef __cplusplus
extern "C"{
#endif 

void * __RPC_USER MIDL_user_allocate(size_t);
void __RPC_USER MIDL_user_free( void * ); 


#ifndef __ClientTrackLib_LIBRARY_DEFINED__
#define __ClientTrackLib_LIBRARY_DEFINED__

/* library ClientTrackLib */
/* [control][helpstring][helpfile][version][uuid] */ 


EXTERN_C const IID LIBID_ClientTrackLib;

#ifndef ___DClientTrack_DISPINTERFACE_DEFINED__
#define ___DClientTrack_DISPINTERFACE_DEFINED__

/* dispinterface _DClientTrack */
/* [helpstring][uuid] */ 


EXTERN_C const IID DIID__DClientTrack;

#if defined(__cplusplus) && !defined(CINTERFACE)

    MIDL_INTERFACE("6376F744-ECE3-4B58-86E0-7EFED8F6DDD9")
    _DClientTrack : public IDispatch
    {
    };
    
#else 	/* C style interface */

    typedef struct _DClientTrackVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            _DClientTrack * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void **ppvObject);
        
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            _DClientTrack * This);
        
        ULONG ( STDMETHODCALLTYPE *Release )( 
            _DClientTrack * This);
        
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfoCount )( 
            _DClientTrack * This,
            /* [out] */ UINT *pctinfo);
        
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfo )( 
            _DClientTrack * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo **ppTInfo);
        
        HRESULT ( STDMETHODCALLTYPE *GetIDsOfNames )( 
            _DClientTrack * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR *rgszNames,
            /* [in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID *rgDispId);
        
        /* [local] */ HRESULT ( STDMETHODCALLTYPE *Invoke )( 
            _DClientTrack * This,
            /* [in] */ DISPID dispIdMember,
            /* [in] */ REFIID riid,
            /* [in] */ LCID lcid,
            /* [in] */ WORD wFlags,
            /* [out][in] */ DISPPARAMS *pDispParams,
            /* [out] */ VARIANT *pVarResult,
            /* [out] */ EXCEPINFO *pExcepInfo,
            /* [out] */ UINT *puArgErr);
        
        END_INTERFACE
    } _DClientTrackVtbl;

    interface _DClientTrack
    {
        CONST_VTBL struct _DClientTrackVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define _DClientTrack_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define _DClientTrack_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define _DClientTrack_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define _DClientTrack_GetTypeInfoCount(This,pctinfo)	\
    (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo)

#define _DClientTrack_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo)

#define _DClientTrack_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)

#define _DClientTrack_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)

#endif /* COBJMACROS */


#endif 	/* C style interface */


#endif 	/* ___DClientTrack_DISPINTERFACE_DEFINED__ */


#ifndef ___DClientTrackEvents_DISPINTERFACE_DEFINED__
#define ___DClientTrackEvents_DISPINTERFACE_DEFINED__

/* dispinterface _DClientTrackEvents */
/* [helpstring][uuid] */ 


EXTERN_C const IID DIID__DClientTrackEvents;

#if defined(__cplusplus) && !defined(CINTERFACE)

    MIDL_INTERFACE("657E8F93-BCA3-463C-98F6-30359044ECBB")
    _DClientTrackEvents : public IDispatch
    {
    };
    
#else 	/* C style interface */

    typedef struct _DClientTrackEventsVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            _DClientTrackEvents * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void **ppvObject);
        
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            _DClientTrackEvents * This);
        
        ULONG ( STDMETHODCALLTYPE *Release )( 
            _DClientTrackEvents * This);
        
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfoCount )( 
            _DClientTrackEvents * This,
            /* [out] */ UINT *pctinfo);
        
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfo )( 
            _DClientTrackEvents * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo **ppTInfo);
        
        HRESULT ( STDMETHODCALLTYPE *GetIDsOfNames )( 
            _DClientTrackEvents * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR *rgszNames,
            /* [in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID *rgDispId);
        
        /* [local] */ HRESULT ( STDMETHODCALLTYPE *Invoke )( 
            _DClientTrackEvents * This,
            /* [in] */ DISPID dispIdMember,
            /* [in] */ REFIID riid,
            /* [in] */ LCID lcid,
            /* [in] */ WORD wFlags,
            /* [out][in] */ DISPPARAMS *pDispParams,
            /* [out] */ VARIANT *pVarResult,
            /* [out] */ EXCEPINFO *pExcepInfo,
            /* [out] */ UINT *puArgErr);
        
        END_INTERFACE
    } _DClientTrackEventsVtbl;

    interface _DClientTrackEvents
    {
        CONST_VTBL struct _DClientTrackEventsVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define _DClientTrackEvents_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define _DClientTrackEvents_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define _DClientTrackEvents_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define _DClientTrackEvents_GetTypeInfoCount(This,pctinfo)	\
    (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo)

#define _DClientTrackEvents_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo)

#define _DClientTrackEvents_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)

#define _DClientTrackEvents_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)

#endif /* COBJMACROS */


#endif 	/* C style interface */


#endif 	/* ___DClientTrackEvents_DISPINTERFACE_DEFINED__ */


EXTERN_C const CLSID CLSID_ClientTrack;

#ifdef __cplusplus

class DECLSPEC_UUID("794834BD-2C77-4D7E-9189-68AA99DC426B")
ClientTrack;
#endif
#endif /* __ClientTrackLib_LIBRARY_DEFINED__ */

/* Additional Prototypes for ALL interfaces */

/* end of Additional Prototypes */

#ifdef __cplusplus
}
#endif

#endif


