/*

Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

*/
module derelict.opendbx.types;

//api.h

/*
 * From sys/time.h
 */
struct timeval {
	long	tv_sec;		/* seconds */
	long	tv_usec;	/* and microseconds */
};

/*
 * From inttypes.h
 */
alias ulong uint64_t;

/*
 *  Extended capabilities supported by the backends
 *  0x0000-0x00ff: Well known capabilities
 */
enum odbxcap {
	ODBX_CAP_BASIC,
	ODBX_CAP_LO
};

/*
 * ODBX bind type
 */
enum odbxbind {
	ODBX_BIND_SIMPLE
};

/*
 *  ODBX error types
 */
enum odbxerr {
	ODBX_ERR_SUCCESS,
	ODBX_ERR_BACKEND,
	ODBX_ERR_NOCAP,
	ODBX_ERR_PARAM,
	ODBX_ERR_NOMEM,
	ODBX_ERR_SIZE,
	ODBX_ERR_NOTEXIST,
	ODBX_ERR_NOOP,
	ODBX_ERR_OPTION,
	ODBX_ERR_OPTRO,
	ODBX_ERR_OPTWR,
	ODBX_ERR_RESULT,
	ODBX_ERR_NOTSUP,
	ODBX_ERR_HANDLE
};

/*
 *  ODBX result/fetch return values
 */
enum odbxres {
	ODBX_RES_DONE,
	ODBX_RES_TIMEOUT,
	ODBX_RES_NOROWS,
	ODBX_RES_ROWS
};

enum odbxrow {
	ODBX_ROW_DONE,
	ODBX_ROW_NEXT
};

/*
 *  ODBX (SQL2003) data types
 */
enum odbxtype {
	ODBX_TYPE_BOOLEAN = 0x00,
	ODBX_TYPE_SMALLINT = 0x01,
	ODBX_TYPE_INTEGER = 0x02,
	ODBX_TYPE_BIGINT = 0x03,
	ODBX_TYPE_DECIMAL = 0x07,
	ODBX_TYPE_REAL = 0x08,
	ODBX_TYPE_DOUBLE = 0x09,
	ODBX_TYPE_FLOAT = 0x0f,
	ODBX_TYPE_CHAR = 0x10,
	ODBX_TYPE_NCHAR = 0x11,
	ODBX_TYPE_VARCHAR = 0x12,
	ODBX_TYPE_NVARCHAR = 0x13,
	ODBX_TYPE_CLOB = 0x20,
	ODBX_TYPE_NCLOB = 0x21,
	ODBX_TYPE_XML = 0x22,
	ODBX_TYPE_BLOB = 0x2f,
	ODBX_TYPE_TIME = 0x30,
	ODBX_TYPE_TIMETZ = 0x31,
	ODBX_TYPE_TIMESTAMP = 0x32,
	ODBX_TYPE_TIMESTAMPTZ = 0x33,
	ODBX_TYPE_DATE = 0x34,
	ODBX_TYPE_INTERVAL = 0x35,
	ODBX_TYPE_ARRAY = 0x40,
	ODBX_TYPE_MULTISET = 0x41,
	ODBX_TYPE_DATALINK = 0x50,
	ODBX_TYPE_UNKNOWN = 0xff
};

/*
 *  ODBX options
 *
 *  0x0000 - 0x1fff reserved for api options
 *  0x2000 - 0x3fff reserved for api extension options
 *  0x4000 - 0xffff reserved for vendor specific and experimental options
 */
enum odbxopt {
/* Informational options */
	ODBX_OPT_API_VERSION = 0x0000,
	ODBX_OPT_THREAD_SAFE = 0x0001,
	ODBX_OPT_LIB_VERSION = 0x0002,

/* Security related options */
	ODBX_OPT_TLS = 0x0010,

/* Implemented options */
	ODBX_OPT_MULTI_STATEMENTS = 0x0020,
	ODBX_OPT_PAGED_RESULTS = 0x0021,
	ODBX_OPT_COMPRESS = 0x0022,
	ODBX_OPT_MODE = 0x0023,
	ODBX_OPT_CONNECT_TIMEOUT = 0x0024
};

/*
 * SSL/TLS related options
 */
enum odbxtls {
	ODBX_TLS_NEVER,
	ODBX_TLS_TRY,
	ODBX_TLS_ALWAYS
};

//odbxdrv.h

/*
 * From sys/types.h
 */
alias int ssize_t;

/*
 *  Commonly used handle and result structures
 */

struct odbx_t
{
	odbx_ops* ops;
	void* backend;
	void* generic;
	void* aux;
};

struct odbx_result_t
{
	odbx_t* handle;
	void* generic;
	void* aux;
};

struct odbx_lo_t
{
	odbx_result_t* result;
	void* generic;
};
	
/*
 *  Structures describing capabilities
 */

struct odbx_basic_ops
{
	int function ( odbx_t* handle, const char* host, const char* port ) init;
	int function ( odbx_t* handle, const char* database, const char* who, const char* cred, int method ) bind;
	int function ( odbx_t* handle ) unbind;
	int function ( odbx_t* handle ) finish;
	int function ( odbx_t* handle, uint option, void* value ) get_option;
	int function ( odbx_t* handle, uint option, void* value ) set_option;
	char* function ( odbx_t* handle ) error;
	int function ( odbx_t* handle ) error_type;
	int function ( odbx_t* handle, const char* from, ulong fromlen, char* to, ulong* tolen ) escape;
	int function ( odbx_t* handle, const char* query, ulong length ) query;
	int function ( odbx_t* handle, odbx_result_t** result, timeval* timeout, ulong chunk ) result;
	int function ( odbx_result_t* result ) result_finish;
	int function ( odbx_result_t* result ) row_fetch;
	uint64_t function ( odbx_result_t* result ) rows_affected;
	ulong function ( odbx_result_t* result ) column_count;
	char* function ( odbx_result_t* result, ulong pos ) column_name;
	int function ( odbx_result_t* result, ulong pos ) column_type;
	ulong function ( odbx_result_t* result, ulong pos ) field_length;
	char* function ( odbx_result_t* result, ulong pos ) field_value;
};

struct odbx_lo_ops
{
	int function ( odbx_result_t* result, odbx_lo_t** lo, const char* value ) open;
	int function ( odbx_lo_t* lo ) close;
	ssize_t function ( odbx_lo_t* lo, void* buffer, size_t buflen ) read;
	ssize_t function ( odbx_lo_t* lo, void* buffer, size_t buflen ) write;
};

struct odbx_ops
{
	odbx_basic_ops* basic;
	odbx_lo_ops* lo;
};

//odbxlib.h