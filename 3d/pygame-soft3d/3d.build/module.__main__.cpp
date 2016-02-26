// Generated code for Python source for module '__main__'
// created by Nuitka version 0.5.0.1

// This code is in part copyright 2013 Kay Hayen.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "nuitka/prelude.hpp"

#include "__modules.hpp"
#include "__constants.hpp"
#include "__helpers.hpp"

// The _module___main__ is a Python object pointer of module type.

// Note: For full compatability with CPython, every module variable access
// needs to go through it except for cases where the module cannot possibly
// have changed in the mean time.

PyObject *module___main__;
PyDictObject *moduledict___main__;

NUITKA_MAY_BE_UNUSED static PyObject *GET_MODULE_VALUE0( PyObject *var_name )
{
    // For module variable values, need to lookup in module dictionary or in
    // built-in dictionary.

    PyObject *result = GET_STRING_DICT_VALUE( moduledict___main__, (Nuitka_StringObject *)var_name );

    if (likely( result != NULL ))
    {
        assertObject( result );

        return result;
    }

    result = GET_STRING_DICT_VALUE( dict_builtin, (Nuitka_StringObject *)var_name );

    if (likely( result != NULL ))
    {
        assertObject( result );

        return result;
    }

    PyErr_Format( PyExc_NameError, "global name '%s' is not defined", Nuitka_String_AsString(var_name ));
    throw PythonException();
}

NUITKA_MAY_BE_UNUSED static PyObject *GET_MODULE_VALUE1( PyObject *var_name )
{
    return INCREASE_REFCOUNT( GET_MODULE_VALUE0( var_name ) );
}

NUITKA_MAY_BE_UNUSED void static DEL_MODULE_VALUE( PyObject *var_name, bool tolerant )
{
    int status = PyDict_DelItem( (PyObject *)moduledict___main__, var_name );

    if (unlikely( status == -1 && tolerant == false ))
    {
        PyErr_Format(
            PyExc_NameError,
            "global name '%s' is not defined",
            Nuitka_String_AsString( var_name )
        );

        throw PythonException();
    }
}

NUITKA_MAY_BE_UNUSED static PyObject *GET_LOCALS_OR_MODULE_VALUE0( PyObject *locals_dict, PyObject *var_name )
{
    PyObject *result = PyDict_GetItem( locals_dict, var_name );

    if ( result != NULL )
    {
        return result;
    }
    else
    {
        return GET_MODULE_VALUE0( var_name );
    }
}

NUITKA_MAY_BE_UNUSED static PyObject *GET_LOCALS_OR_MODULE_VALUE1( PyObject *locals_dict, PyObject *var_name )
{
    PyObject *result = PyDict_GetItem( locals_dict, var_name );

    if ( result != NULL )
    {
        return INCREASE_REFCOUNT( result );
    }
    else
    {
        return GET_MODULE_VALUE1( var_name );
    }
}

// The module function declarations.
NUITKA_LOCAL_MODULE PyObject *impl_class_1_SoftContext_of_module___main__(  );


NUITKA_LOCAL_MODULE PyObject *impl_listcontr_1_of_function_1___init___of_class_1_SoftContext_of_module___main__( PyObject *_python_par___iterator, PyObjectLocalVariable &closure_i );


NUITKA_LOCAL_MODULE PyObject *impl_listcontr_1_of_function_14_main_of_module___main__( PyObject *_python_par___iterator, PyObjectLocalVariable &closure_quad, PyObjectLocalVariable &closure_spd );


NUITKA_LOCAL_MODULE PyObject *impl_listcontr_2_of_function_14_main_of_module___main__( PyObject *_python_par___iterator, PyObjectLocalVariable &closure_quad, PyObjectLocalVariable &closure_spd );


NUITKA_LOCAL_MODULE PyObject *impl_listcontr_3_of_function_14_main_of_module___main__( PyObject *_python_par___iterator, PyObjectLocalVariable &closure_quad, PyObjectLocalVariable &closure_spd );


NUITKA_LOCAL_MODULE PyObject *impl_listcontr_4_of_function_14_main_of_module___main__( PyObject *_python_par___iterator, PyObjectLocalVariable &closure_quad, PyObjectLocalVariable &closure_spd );


NUITKA_LOCAL_MODULE PyObject *impl_listcontr_5_of_function_14_main_of_module___main__( PyObject *_python_par___iterator, PyObjectLocalVariable &closure_quad, PyObjectLocalVariable &closure_spd );


NUITKA_LOCAL_MODULE PyObject *impl_listcontr_6_of_function_14_main_of_module___main__( PyObject *_python_par___iterator, PyObjectLocalVariable &closure_quad, PyObjectLocalVariable &closure_spd );


NUITKA_LOCAL_MODULE PyObject *impl_listcontr_7_of_function_14_main_of_module___main__( PyObject *_python_par___iterator, PyObjectLocalVariable &closure_q, PyObjectLocalVariable &closure_quads );


NUITKA_LOCAL_MODULE PyObject *impl_listcontr_8_of_function_14_main_of_module___main__( PyObject *_python_par___iterator, PyObjectLocalVariable &closure_q, PyObjectLocalVariable &closure_quads );


NUITKA_LOCAL_MODULE PyObject *impl_listcontr_9_of_function_14_main_of_module___main__( PyObject *_python_par___iterator, PyObjectLocalVariable &closure_q, PyObjectLocalVariable &closure_quads );


NUITKA_LOCAL_MODULE PyObject *impl_listcontr_10_of_function_14_main_of_module___main__( PyObject *_python_par___iterator, PyObjectLocalVariable &closure_q, PyObjectLocalVariable &closure_quads );


static PyObject *MAKE_FUNCTION_function_10_draw_line_of_module___main__(  );


static PyObject *MAKE_FUNCTION_function_11_draw_tri_point_up_of_module___main__(  );


static PyObject *MAKE_FUNCTION_function_12_draw_tri_point_down_of_module___main__(  );


static PyObject *MAKE_FUNCTION_function_13_draw_quad_of_module___main__(  );


static PyObject *MAKE_FUNCTION_function_14_main_of_module___main__(  );


static PyObject *MAKE_FUNCTION_function_1___init___of_class_1_SoftContext_of_module___main__(  );


static PyObject *MAKE_FUNCTION_function_2_load_tex_of_module___main__(  );


static PyObject *MAKE_FUNCTION_function_2_trans_of_class_1_SoftContext_of_module___main__(  );


static PyObject *MAKE_FUNCTION_function_3_draw_of_class_1_SoftContext_of_module___main__(  );


static PyObject *MAKE_FUNCTION_function_3_trans_of_module___main__(  );


static PyObject *MAKE_FUNCTION_function_4_push_of_module___main__(  );


static PyObject *MAKE_FUNCTION_function_5_uvscroll_of_module___main__(  );


static PyObject *MAKE_FUNCTION_function_6_scale_of_module___main__(  );


static PyObject *MAKE_FUNCTION_function_7_draw_point_of_module___main__(  );


static PyObject *MAKE_FUNCTION_function_8_draw_tri_of_module___main__(  );


static PyObject *MAKE_FUNCTION_function_9_draw_tri_split_of_module___main__(  );


static PyObject *MAKE_FUNCTION_lambda_1_lambda_of_function_11_draw_tri_point_up_of_module___main__(  );


static PyObject *MAKE_FUNCTION_lambda_1_lambda_of_function_3_draw_of_class_1_SoftContext_of_module___main__(  );


static PyObject *MAKE_FUNCTION_lambda_1_lambda_of_function_8_draw_tri_of_module___main__(  );


// The module function definitions.
NUITKA_LOCAL_MODULE PyObject *impl_class_1_SoftContext_of_module___main__(  )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalVariable var___module__( const_str_plain___module__ );
    PyObjectLocalVariable var___init__( const_str_plain___init__ );
    PyObjectLocalVariable var_trans( const_str_plain_trans );
    PyObjectLocalVariable var_draw( const_str_plain_draw );

    // Actual function code.
    var___module__.assign0( const_str_plain___main__ );
    var___init__.assign1( MAKE_FUNCTION_function_1___init___of_class_1_SoftContext_of_module___main__(  ) );
    var_trans.assign1( MAKE_FUNCTION_function_2_trans_of_class_1_SoftContext_of_module___main__(  ) );
    var_draw.assign1( MAKE_FUNCTION_function_3_draw_of_class_1_SoftContext_of_module___main__(  ) );
    return var_draw.updateLocalsDict( var_trans.updateLocalsDict( var___init__.updateLocalsDict( var___module__.updateLocalsDict( PyDict_New() ) ) ) );
}


static PyObject *impl_function_1___init___of_class_1_SoftContext_of_module___main__( Nuitka_FunctionObject *self, PyObject *_python_par_self, PyObject *_python_par_s_w, PyObject *_python_par_s_h, PyObject *_python_par_r_w, PyObject *_python_par_r_h )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par_self( const_str_plain_self, _python_par_self );
    PyObjectLocalParameterVariableNoDel par_s_w( const_str_plain_s_w, _python_par_s_w );
    PyObjectLocalParameterVariableNoDel par_s_h( const_str_plain_s_h, _python_par_s_h );
    PyObjectLocalParameterVariableNoDel par_r_w( const_str_plain_r_w, _python_par_r_w );
    PyObjectLocalParameterVariableNoDel par_r_h( const_str_plain_r_h, _python_par_r_h );
    PyObjectLocalVariable var_i( const_str_plain_i );

    // Actual function code.
    static PyFrameObject *frame_function_1___init___of_class_1_SoftContext_of_module___main__ = NULL;

    if ( isFrameUnusable( frame_function_1___init___of_class_1_SoftContext_of_module___main__ ) )
    {
        if ( frame_function_1___init___of_class_1_SoftContext_of_module___main__ )
        {
#if _DEBUG_REFRAME
            puts( "reframe for function_1___init___of_class_1_SoftContext_of_module___main__" );
#endif
            Py_DECREF( frame_function_1___init___of_class_1_SoftContext_of_module___main__ );
        }

        frame_function_1___init___of_class_1_SoftContext_of_module___main__ = MAKE_FRAME( codeobj_f3375d8da0f2b9ee9ee080e565498646, module___main__ );
    }

    FrameGuard frame_guard( frame_function_1___init___of_class_1_SoftContext_of_module___main__ );
    try
    {
        assert( Py_REFCNT( frame_function_1___init___of_class_1_SoftContext_of_module___main__ ) == 2 ); // Frame stack
        frame_guard.setLineNumber( 21 );
        {
            PyObject *tmp_identifier = par_s_w.asObject0();
            SET_ATTRIBUTE( tmp_identifier, par_self.asObject0(), const_str_plain_s_w );
        }
        frame_guard.setLineNumber( 22 );
        {
            PyObject *tmp_identifier = par_s_h.asObject0();
            SET_ATTRIBUTE( tmp_identifier, par_self.asObject0(), const_str_plain_s_h );
        }
        frame_guard.setLineNumber( 23 );
        {
            PyObject *tmp_identifier = par_r_w.asObject0();
            SET_ATTRIBUTE( tmp_identifier, par_self.asObject0(), const_str_plain_r_w );
        }
        frame_guard.setLineNumber( 24 );
        {
            PyObject *tmp_identifier = par_r_h.asObject0();
            SET_ATTRIBUTE( tmp_identifier, par_self.asObject0(), const_str_plain_r_h );
        }
        frame_guard.setLineNumber( 25 );
        {
            PyObjectTempKeeper1 call1;
            PyObjectTempKeeper0 make_list1;
            {
                PyObjectTemporary tmp_identifier( CALL_FUNCTION_NO_ARGS( PyObjectTemporary( LOOKUP_ATTRIBUTE( PyObjectTemporary( ( call1.assign( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_Surface ) ), CALL_FUNCTION_WITH_ARGS1( call1.asObject0(), PyObjectTemporary( ( make_list1.assign( par_s_w.asObject0() ), MAKE_LIST2( make_list1.asObject1(), par_s_h.asObject1() ) ) ).asObject0() ) ) ).asObject0(), const_str_plain_convert ) ).asObject0() ) );
                SET_ATTRIBUTE( tmp_identifier.asObject0(), par_self.asObject0(), const_str_plain_surf );
            }
        }
        frame_guard.setLineNumber( 26 );
        {
            PyObjectTempKeeper1 call1;
            {
                PyObjectTemporary tmp_identifier( ( call1.assign( LOOKUP_ATTRIBUTE( PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_surfarray ) ).asObject0(), const_str_plain_pixels2d ) ), CALL_FUNCTION_WITH_ARGS1( call1.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( par_self.asObject0(), const_str_plain_surf ) ).asObject0() ) ) );
                SET_ATTRIBUTE( tmp_identifier.asObject0(), par_self.asObject0(), const_str_plain_arr );
            }
        }
        frame_guard.setLineNumber( 27 );
        {
            PyObjectTempKeeper0 op1;
            {
                PyObjectTemporary tmp_identifier( impl_listcontr_1_of_function_1___init___of_class_1_SoftContext_of_module___main__( MAKE_ITERATOR( PyObjectTemporary( BUILTIN_RANGE( PyObjectTemporary( ( op1.assign( par_s_w.asObject0() ), BINARY_OPERATION_MUL( op1.asObject0(), par_s_h.asObject0() ) ) ).asObject0() ) ).asObject0() ), var_i ) );
                SET_ATTRIBUTE( tmp_identifier.asObject0(), par_self.asObject0(), const_str_plain_odepth );
            }
        }
    }
    catch ( PythonException &_exception )
    {
        if ( !_exception.hasTraceback() )
        {
            _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
        }
        else
        {
            _exception.addTraceback( frame_guard.getFrame0() );
        }

        Py_XDECREF( frame_guard.getFrame0()->f_locals );
        frame_guard.getFrame0()->f_locals = par_r_h.updateLocalsDict( par_r_w.updateLocalsDict( par_s_h.updateLocalsDict( par_s_w.updateLocalsDict( par_self.updateLocalsDict( var_i.updateLocalsDict( PyDict_New() ) ) ) ) ) );

        if ( frame_guard.getFrame0() == frame_function_1___init___of_class_1_SoftContext_of_module___main__ )
        {
           Py_DECREF( frame_function_1___init___of_class_1_SoftContext_of_module___main__ );
           frame_function_1___init___of_class_1_SoftContext_of_module___main__ = NULL;
        }

        _exception.toPython();
        return NULL;
    }
    return INCREASE_REFCOUNT( Py_None );
}
static PyObject *fparse_function_1___init___of_class_1_SoftContext_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, Py_ssize_t args_size, PyObject *kw )
{
    assert( kw == NULL || PyDict_Check( kw ) );

    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_size = kw ? PyDict_Size( kw ) : 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_found = 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_only_found = 0;
    Py_ssize_t args_given = args_size;
    PyObject *_python_par_self = NULL;
    PyObject *_python_par_s_w = NULL;
    PyObject *_python_par_s_h = NULL;
    PyObject *_python_par_r_w = NULL;
    PyObject *_python_par_r_h = NULL;
    // Copy given dictionary values to the the respective variables:
    if ( kw_size > 0 )
    {
        Py_ssize_t ppos = 0;
        PyObject *key, *value;

        while( PyDict_Next( kw, &ppos, &key, &value ) )
        {
#if PYTHON_VERSION < 300
            if (unlikely( !PyString_Check( key ) && !PyUnicode_Check( key ) ))
#else
            if (unlikely( !PyUnicode_Check( key ) ))
#endif
            {
                PyErr_Format( PyExc_TypeError, "__init__() keywords must be strings" );
                goto error_exit;
            }

            NUITKA_MAY_BE_UNUSED bool found = false;

            Py_INCREF( key );
            Py_INCREF( value );

            // Quick path, could be our value.
            if ( found == false && const_str_plain_self == key )
            {
                assert( _python_par_self == NULL );
                _python_par_self = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_s_w == key )
            {
                assert( _python_par_s_w == NULL );
                _python_par_s_w = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_s_h == key )
            {
                assert( _python_par_s_h == NULL );
                _python_par_s_h = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_r_w == key )
            {
                assert( _python_par_r_w == NULL );
                _python_par_r_w = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_r_h == key )
            {
                assert( _python_par_r_h == NULL );
                _python_par_r_h = value;

                found = true;
                kw_found += 1;
            }

            // Slow path, compare against all parameter names.
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_self, key ) )
            {
                assert( _python_par_self == NULL );
                _python_par_self = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_s_w, key ) )
            {
                assert( _python_par_s_w == NULL );
                _python_par_s_w = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_s_h, key ) )
            {
                assert( _python_par_s_h == NULL );
                _python_par_s_h = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_r_w, key ) )
            {
                assert( _python_par_r_w == NULL );
                _python_par_r_w = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_r_h, key ) )
            {
                assert( _python_par_r_h == NULL );
                _python_par_r_h = value;

                found = true;
                kw_found += 1;
            }


            Py_DECREF( key );

            if ( found == false )
            {
               Py_DECREF( value );

               PyErr_Format(
                   PyExc_TypeError,
                   "__init__() got an unexpected keyword argument '%s'",
                   Nuitka_String_Check( key ) ? Nuitka_String_AsString( key ) : "<non-string>"
               );

               goto error_exit;
            }
        }

#if PYTHON_VERSION < 300
        assert( kw_found == kw_size );
        assert( kw_only_found == 0 );
#endif
    }

    // Check if too many arguments were given in case of non star args
    if (unlikely( args_given > 5 ))
    {
#if PYTHON_VERSION < 270
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_size );
#elif PYTHON_VERSION < 330
        ERROR_TOO_MANY_ARGUMENTS( self, args_given + kw_found );
#else
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_only_found );
#endif
        goto error_exit;
    }


    // Copy normal parameter values given as part of the args list to the respective variables:

    if (likely( 0 < args_given ))
    {
         if (unlikely( _python_par_self != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 0 );
             goto error_exit;
         }

        _python_par_self = INCREASE_REFCOUNT( args[ 0 ] );
    }
    else if ( _python_par_self == NULL )
    {
        if ( 0 + self->m_defaults_given >= 5  )
        {
            _python_par_self = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 0 - 5 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 1 < args_given ))
    {
         if (unlikely( _python_par_s_w != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 1 );
             goto error_exit;
         }

        _python_par_s_w = INCREASE_REFCOUNT( args[ 1 ] );
    }
    else if ( _python_par_s_w == NULL )
    {
        if ( 1 + self->m_defaults_given >= 5  )
        {
            _python_par_s_w = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 1 - 5 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 2 < args_given ))
    {
         if (unlikely( _python_par_s_h != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 2 );
             goto error_exit;
         }

        _python_par_s_h = INCREASE_REFCOUNT( args[ 2 ] );
    }
    else if ( _python_par_s_h == NULL )
    {
        if ( 2 + self->m_defaults_given >= 5  )
        {
            _python_par_s_h = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 2 - 5 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 3 < args_given ))
    {
         if (unlikely( _python_par_r_w != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 3 );
             goto error_exit;
         }

        _python_par_r_w = INCREASE_REFCOUNT( args[ 3 ] );
    }
    else if ( _python_par_r_w == NULL )
    {
        if ( 3 + self->m_defaults_given >= 5  )
        {
            _python_par_r_w = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 3 - 5 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 4 < args_given ))
    {
         if (unlikely( _python_par_r_h != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 4 );
             goto error_exit;
         }

        _python_par_r_h = INCREASE_REFCOUNT( args[ 4 ] );
    }
    else if ( _python_par_r_h == NULL )
    {
        if ( 4 + self->m_defaults_given >= 5  )
        {
            _python_par_r_h = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 4 - 5 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }

#if PYTHON_VERSION >= 330
    if (unlikely( _python_par_self == NULL || _python_par_s_w == NULL || _python_par_s_h == NULL || _python_par_r_w == NULL || _python_par_r_h == NULL ))
    {
        PyObject *values[] = { _python_par_self, _python_par_s_w, _python_par_s_h, _python_par_r_w, _python_par_r_h };
        ERROR_TOO_FEW_ARGUMENTS( self, values );

        goto error_exit;
    }
#endif


    return impl_function_1___init___of_class_1_SoftContext_of_module___main__( self, _python_par_self, _python_par_s_w, _python_par_s_h, _python_par_r_w, _python_par_r_h );

error_exit:;

    Py_XDECREF( _python_par_self );
    Py_XDECREF( _python_par_s_w );
    Py_XDECREF( _python_par_s_h );
    Py_XDECREF( _python_par_r_w );
    Py_XDECREF( _python_par_r_h );

    return NULL;
}

static PyObject *dparse_function_1___init___of_class_1_SoftContext_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, int size )
{
    if ( size == 5 )
    {
        return impl_function_1___init___of_class_1_SoftContext_of_module___main__( self, INCREASE_REFCOUNT( args[ 0 ] ), INCREASE_REFCOUNT( args[ 1 ] ), INCREASE_REFCOUNT( args[ 2 ] ), INCREASE_REFCOUNT( args[ 3 ] ), INCREASE_REFCOUNT( args[ 4 ] ) );
    }
    else
    {
        PyObject *result = fparse_function_1___init___of_class_1_SoftContext_of_module___main__( self, args, size, NULL );
        return result;
    }

}



NUITKA_LOCAL_MODULE PyObject *impl_listcontr_1_of_function_1___init___of_class_1_SoftContext_of_module___main__( PyObject *_python_par___iterator, PyObjectLocalVariable &closure_i )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par___iterator( const_str_plain__SoftContext__iterator, _python_par___iterator );
    PyObjectTempVariable tmp_iter_value_0;

    // Actual function code.
    PyObjectTemporary tmp_result( PyList_New( 0 ) );
    FrameGuardVeryLight frame_guard;

    PyObject *tmp_contraction_iter_0 = par___iterator.asObject0();
    while( true )
    {
        frame_guard.setLineNumber( 27 );
        PyObject *_tmp_unpack_1 = ITERATOR_NEXT( tmp_contraction_iter_0 );

        if ( _tmp_unpack_1 == NULL )
        {
            break;
        }
        tmp_iter_value_0.assign1( _tmp_unpack_1 );
        closure_i.assign0( tmp_iter_value_0.asObject0() );
        APPEND_TO_LIST( tmp_result.asObject0(), const_int_pos_1000 ), Py_None;

        CONSIDER_THREADING();
    }
    tmp_contraction_iter_0 = NULL;
    return tmp_result.asObject1();
}


static PyObject *impl_function_2_trans_of_class_1_SoftContext_of_module___main__( Nuitka_FunctionObject *self, PyObject *_python_par_self, PyObject *_python_par_p )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par_self( const_str_plain_self, _python_par_self );
    PyObjectLocalParameterVariableNoDel par_p( const_str_plain_p, _python_par_p );
    PyObjectLocalVariable var_c( const_str_plain_c );
    PyObjectLocalVariable var_x( const_str_plain_x );
    PyObjectLocalVariable var_y( const_str_plain_y );
    PyObjectLocalVariable var_z( const_str_plain_z );
    PyObjectLocalVariable var_u( const_str_plain_u );
    PyObjectLocalVariable var_v( const_str_plain_v );
    PyObjectLocalVariable var_d( const_str_plain_d );
    PyObjectTempVariable tmp_tuple_unpack_1__source_iter;
    PyObjectTempVariable tmp_tuple_unpack_1__element_1;
    PyObjectTempVariable tmp_tuple_unpack_1__element_2;
    PyObjectTempVariable tmp_tuple_unpack_1__element_3;
    PyObjectTempVariable tmp_tuple_unpack_1__element_4;
    PyObjectTempVariable tmp_tuple_unpack_1__element_5;

    // Actual function code.
    static PyFrameObject *frame_function_2_trans_of_class_1_SoftContext_of_module___main__ = NULL;

    if ( isFrameUnusable( frame_function_2_trans_of_class_1_SoftContext_of_module___main__ ) )
    {
        if ( frame_function_2_trans_of_class_1_SoftContext_of_module___main__ )
        {
#if _DEBUG_REFRAME
            puts( "reframe for function_2_trans_of_class_1_SoftContext_of_module___main__" );
#endif
            Py_DECREF( frame_function_2_trans_of_class_1_SoftContext_of_module___main__ );
        }

        frame_function_2_trans_of_class_1_SoftContext_of_module___main__ = MAKE_FRAME( codeobj_d6af5cfc9c76cf3f9190f2b3ee859cff, module___main__ );
    }

    FrameGuard frame_guard( frame_function_2_trans_of_class_1_SoftContext_of_module___main__ );
    try
    {
        assert( Py_REFCNT( frame_function_2_trans_of_class_1_SoftContext_of_module___main__ ) == 2 ); // Frame stack
        frame_guard.setLineNumber( 29 );
        var_c.assign0( par_self.asObject0() );
        frame_guard.setLineNumber( 30 );
        PythonExceptionKeeper _caught_1;
#if PYTHON_VERSION < 300
        int _at_lineno_1 = 0;
#endif


        try
        {
            // Tried block:
            tmp_tuple_unpack_1__source_iter.assign1( MAKE_ITERATOR( par_p.asObject0() ) );
            tmp_tuple_unpack_1__element_1.assign1( UNPACK_NEXT( tmp_tuple_unpack_1__source_iter.asObject0(), 0 ) );
            tmp_tuple_unpack_1__element_2.assign1( UNPACK_NEXT( tmp_tuple_unpack_1__source_iter.asObject0(), 1 ) );
            tmp_tuple_unpack_1__element_3.assign1( UNPACK_NEXT( tmp_tuple_unpack_1__source_iter.asObject0(), 2 ) );
            tmp_tuple_unpack_1__element_4.assign1( UNPACK_NEXT( tmp_tuple_unpack_1__source_iter.asObject0(), 3 ) );
            tmp_tuple_unpack_1__element_5.assign1( UNPACK_NEXT( tmp_tuple_unpack_1__source_iter.asObject0(), 4 ) );
            UNPACK_ITERATOR_CHECK( tmp_tuple_unpack_1__source_iter.asObject0(), 5 );
            var_x.assign0( tmp_tuple_unpack_1__element_1.asObject0() );
            var_y.assign0( tmp_tuple_unpack_1__element_2.asObject0() );
            var_z.assign0( tmp_tuple_unpack_1__element_3.asObject0() );
            var_u.assign0( tmp_tuple_unpack_1__element_4.asObject0() );
            var_v.assign0( tmp_tuple_unpack_1__element_5.asObject0() );
        }
        catch ( PythonException &_exception )
        {
#if PYTHON_VERSION >= 300
            if ( !_exception.hasTraceback() )
            {
                _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
            }
            else
            {
                _exception.addTraceback( frame_guard.getFrame0() );
            }
#else
            _at_lineno_1 = frame_guard.getLineNumber();
#endif

            _caught_1.save( _exception );

#if PYTHON_VERSION >= 300
            frame_guard.preserveExistingException();

            _exception.toExceptionHandler();
#endif
        }

        // Final block:
        tmp_tuple_unpack_1__source_iter.del( true );
        tmp_tuple_unpack_1__element_1.del( true );
        tmp_tuple_unpack_1__element_2.del( true );
        tmp_tuple_unpack_1__element_3.del( true );
        tmp_tuple_unpack_1__element_4.del( true );
        tmp_tuple_unpack_1__element_5.del( true );
#if PYTHON_VERSION < 300
        if ( _at_lineno_1 != 0 )
        {
           frame_guard.setLineNumber( _at_lineno_1 );
        }
#endif
        _caught_1.rethrow();
        // Final end
        frame_guard.setLineNumber( 31 );
        var_z.assign1( TO_FLOAT( PyObjectTemporary( BINARY_OPERATION_ADD( PyObjectTemporary( BINARY_OPERATION_DIV( PyObjectTemporary( BINARY_OPERATION_MUL( var_z.asObject0(), const_float_1_0 ) ).asObject0(), const_float_300_0 ) ).asObject0(), const_int_pos_1 ) ).asObject0() ) );
        frame_guard.setLineNumber( 32 );
        if ( RICH_COMPARE_BOOL_EQ( var_z.asObject0(), const_int_0 ) )
        {
            var_z.assign0( const_float_0_001 );
        }
        frame_guard.setLineNumber( 34 );
        var_d.assign1( LOOKUP_ATTRIBUTE( var_c.asObject0(), const_str_plain_s_w ) );
        frame_guard.setLineNumber( 35 );
        {
            PyObjectTempKeeper0 op1;
            PyObjectTempKeeper1 op2;
            PyObjectTempKeeper1 op3;
            var_x.assign1( ( op3.assign( ( op2.assign( ( op1.assign( var_d.asObject0() ), BINARY_OPERATION_MUL( op1.asObject0(), var_x.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), PyObjectTemporary( TO_FLOAT( PyObjectTemporary( LOOKUP_ATTRIBUTE( var_c.asObject0(), const_str_plain_r_w ) ).asObject0() ) ).asObject0() ) ) ), BINARY_OPERATION_DIV( op3.asObject0(), var_z.asObject0() ) ) );
        }
        frame_guard.setLineNumber( 36 );
        PyObject *tmp_inplace_assign_1__inplace_start = var_x.asObject0();
        PyObject *_tmp_inplace_assign_1__inplace_end;
        {
            PyObjectTempKeeper0 op1;
            _tmp_inplace_assign_1__inplace_end = ( op1.assign( tmp_inplace_assign_1__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), PyObjectTemporary( BINARY_OPERATION( PyNumber_FloorDivide, PyObjectTemporary( LOOKUP_ATTRIBUTE( var_c.asObject0(), const_str_plain_s_w ) ).asObject0(), const_int_pos_2 ) ).asObject0() ) );
        }
        PyObjectTemporary tmp_inplace_assign_1__inplace_end( _tmp_inplace_assign_1__inplace_end );
        if ( ( tmp_inplace_assign_1__inplace_start != tmp_inplace_assign_1__inplace_end.asObject0() ) )
        {
            var_x.assign0( tmp_inplace_assign_1__inplace_end.asObject0() );
        }
        frame_guard.setLineNumber( 37 );
        var_d.assign1( LOOKUP_ATTRIBUTE( var_c.asObject0(), const_str_plain_s_h ) );
        frame_guard.setLineNumber( 38 );
        {
            PyObjectTempKeeper0 op1;
            PyObjectTempKeeper1 op2;
            PyObjectTempKeeper1 op3;
            var_y.assign1( ( op3.assign( ( op2.assign( ( op1.assign( var_d.asObject0() ), BINARY_OPERATION_MUL( op1.asObject0(), var_y.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), PyObjectTemporary( TO_FLOAT( PyObjectTemporary( LOOKUP_ATTRIBUTE( var_c.asObject0(), const_str_plain_r_w ) ).asObject0() ) ).asObject0() ) ) ), BINARY_OPERATION_DIV( op3.asObject0(), var_z.asObject0() ) ) );
        }
        frame_guard.setLineNumber( 39 );
        PyObject *tmp_inplace_assign_2__inplace_start = var_y.asObject0();
        PyObject *_tmp_inplace_assign_2__inplace_end;
        {
            PyObjectTempKeeper0 op1;
            _tmp_inplace_assign_2__inplace_end = ( op1.assign( tmp_inplace_assign_2__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), PyObjectTemporary( BINARY_OPERATION( PyNumber_FloorDivide, PyObjectTemporary( LOOKUP_ATTRIBUTE( var_c.asObject0(), const_str_plain_s_h ) ).asObject0(), const_int_pos_2 ) ).asObject0() ) );
        }
        PyObjectTemporary tmp_inplace_assign_2__inplace_end( _tmp_inplace_assign_2__inplace_end );
        if ( ( tmp_inplace_assign_2__inplace_start != tmp_inplace_assign_2__inplace_end.asObject0() ) )
        {
            var_y.assign0( tmp_inplace_assign_2__inplace_end.asObject0() );
        }
        frame_guard.setLineNumber( 40 );
        {
            PyObjectTempKeeper0 make_list1;
            PyObjectTempKeeper0 make_list2;
            PyObjectTempKeeper0 make_list3;
            PyObjectTempKeeper0 make_list4;
            return ( make_list1.assign( var_x.asObject0() ), make_list2.assign( var_y.asObject0() ), make_list3.assign( var_z.asObject0() ), make_list4.assign( var_u.asObject0() ), MAKE_LIST5( make_list1.asObject1(), make_list2.asObject1(), make_list3.asObject1(), make_list4.asObject1(), var_v.asObject1() ) );
        }
    }
    catch ( PythonException &_exception )
    {
        if ( !_exception.hasTraceback() )
        {
            _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
        }
        else
        {
            _exception.addTraceback( frame_guard.getFrame0() );
        }

        Py_XDECREF( frame_guard.getFrame0()->f_locals );
        frame_guard.getFrame0()->f_locals = par_p.updateLocalsDict( par_self.updateLocalsDict( var_d.updateLocalsDict( var_v.updateLocalsDict( var_u.updateLocalsDict( var_z.updateLocalsDict( var_y.updateLocalsDict( var_x.updateLocalsDict( var_c.updateLocalsDict( PyDict_New() ) ) ) ) ) ) ) ) );

        if ( frame_guard.getFrame0() == frame_function_2_trans_of_class_1_SoftContext_of_module___main__ )
        {
           Py_DECREF( frame_function_2_trans_of_class_1_SoftContext_of_module___main__ );
           frame_function_2_trans_of_class_1_SoftContext_of_module___main__ = NULL;
        }

        _exception.toPython();
        return NULL;
    }

}
static PyObject *fparse_function_2_trans_of_class_1_SoftContext_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, Py_ssize_t args_size, PyObject *kw )
{
    assert( kw == NULL || PyDict_Check( kw ) );

    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_size = kw ? PyDict_Size( kw ) : 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_found = 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_only_found = 0;
    Py_ssize_t args_given = args_size;
    PyObject *_python_par_self = NULL;
    PyObject *_python_par_p = NULL;
    // Copy given dictionary values to the the respective variables:
    if ( kw_size > 0 )
    {
        Py_ssize_t ppos = 0;
        PyObject *key, *value;

        while( PyDict_Next( kw, &ppos, &key, &value ) )
        {
#if PYTHON_VERSION < 300
            if (unlikely( !PyString_Check( key ) && !PyUnicode_Check( key ) ))
#else
            if (unlikely( !PyUnicode_Check( key ) ))
#endif
            {
                PyErr_Format( PyExc_TypeError, "trans() keywords must be strings" );
                goto error_exit;
            }

            NUITKA_MAY_BE_UNUSED bool found = false;

            Py_INCREF( key );
            Py_INCREF( value );

            // Quick path, could be our value.
            if ( found == false && const_str_plain_self == key )
            {
                assert( _python_par_self == NULL );
                _python_par_self = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_p == key )
            {
                assert( _python_par_p == NULL );
                _python_par_p = value;

                found = true;
                kw_found += 1;
            }

            // Slow path, compare against all parameter names.
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_self, key ) )
            {
                assert( _python_par_self == NULL );
                _python_par_self = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_p, key ) )
            {
                assert( _python_par_p == NULL );
                _python_par_p = value;

                found = true;
                kw_found += 1;
            }


            Py_DECREF( key );

            if ( found == false )
            {
               Py_DECREF( value );

               PyErr_Format(
                   PyExc_TypeError,
                   "trans() got an unexpected keyword argument '%s'",
                   Nuitka_String_Check( key ) ? Nuitka_String_AsString( key ) : "<non-string>"
               );

               goto error_exit;
            }
        }

#if PYTHON_VERSION < 300
        assert( kw_found == kw_size );
        assert( kw_only_found == 0 );
#endif
    }

    // Check if too many arguments were given in case of non star args
    if (unlikely( args_given > 2 ))
    {
#if PYTHON_VERSION < 270
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_size );
#elif PYTHON_VERSION < 330
        ERROR_TOO_MANY_ARGUMENTS( self, args_given + kw_found );
#else
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_only_found );
#endif
        goto error_exit;
    }


    // Copy normal parameter values given as part of the args list to the respective variables:

    if (likely( 0 < args_given ))
    {
         if (unlikely( _python_par_self != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 0 );
             goto error_exit;
         }

        _python_par_self = INCREASE_REFCOUNT( args[ 0 ] );
    }
    else if ( _python_par_self == NULL )
    {
        if ( 0 + self->m_defaults_given >= 2  )
        {
            _python_par_self = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 0 - 2 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 1 < args_given ))
    {
         if (unlikely( _python_par_p != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 1 );
             goto error_exit;
         }

        _python_par_p = INCREASE_REFCOUNT( args[ 1 ] );
    }
    else if ( _python_par_p == NULL )
    {
        if ( 1 + self->m_defaults_given >= 2  )
        {
            _python_par_p = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 1 - 2 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }

#if PYTHON_VERSION >= 330
    if (unlikely( _python_par_self == NULL || _python_par_p == NULL ))
    {
        PyObject *values[] = { _python_par_self, _python_par_p };
        ERROR_TOO_FEW_ARGUMENTS( self, values );

        goto error_exit;
    }
#endif


    return impl_function_2_trans_of_class_1_SoftContext_of_module___main__( self, _python_par_self, _python_par_p );

error_exit:;

    Py_XDECREF( _python_par_self );
    Py_XDECREF( _python_par_p );

    return NULL;
}

static PyObject *dparse_function_2_trans_of_class_1_SoftContext_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, int size )
{
    if ( size == 2 )
    {
        return impl_function_2_trans_of_class_1_SoftContext_of_module___main__( self, INCREASE_REFCOUNT( args[ 0 ] ), INCREASE_REFCOUNT( args[ 1 ] ) );
    }
    else
    {
        PyObject *result = fparse_function_2_trans_of_class_1_SoftContext_of_module___main__( self, args, size, NULL );
        return result;
    }

}



static PyObject *impl_function_3_draw_of_class_1_SoftContext_of_module___main__( Nuitka_FunctionObject *self, PyObject *_python_par_self, PyObject *_python_par_quads )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par_self( const_str_plain_self, _python_par_self );
    PyObjectLocalParameterVariableNoDel par_quads( const_str_plain_quads, _python_par_quads );
    PyObjectLocalVariable var_q( const_str_plain_q );
    PyObjectLocalVariable var_surf( const_str_plain_surf );
    PyObjectTempVariable tmp_for_loop_1__iter_value;

    // Actual function code.
    static PyFrameObject *frame_function_3_draw_of_class_1_SoftContext_of_module___main__ = NULL;

    if ( isFrameUnusable( frame_function_3_draw_of_class_1_SoftContext_of_module___main__ ) )
    {
        if ( frame_function_3_draw_of_class_1_SoftContext_of_module___main__ )
        {
#if _DEBUG_REFRAME
            puts( "reframe for function_3_draw_of_class_1_SoftContext_of_module___main__" );
#endif
            Py_DECREF( frame_function_3_draw_of_class_1_SoftContext_of_module___main__ );
        }

        frame_function_3_draw_of_class_1_SoftContext_of_module___main__ = MAKE_FRAME( codeobj_8dd925001acdaa29a140c8c40efbcc46, module___main__ );
    }

    FrameGuard frame_guard( frame_function_3_draw_of_class_1_SoftContext_of_module___main__ );
    try
    {
        assert( Py_REFCNT( frame_function_3_draw_of_class_1_SoftContext_of_module___main__ ) == 2 ); // Frame stack
        frame_guard.setLineNumber( 42 );
        {
            PyObjectTemporary tmp_identifier( LOOKUP_ATTRIBUTE( par_self.asObject0(), const_str_plain_arr ) );
            SET_ATTRIBUTE( tmp_identifier.asObject0(), GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_arr );
        }
        frame_guard.setLineNumber( 43 );
        {
            PyObjectTemporary tmp_identifier( LOOKUP_INDEX_SLICE( PyObjectTemporary( LOOKUP_ATTRIBUTE( par_self.asObject0(), const_str_plain_odepth ) ).asObject0(), 0, PY_SSIZE_T_MAX ) );
            SET_ATTRIBUTE( tmp_identifier.asObject0(), GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_depth );
        }
        frame_guard.setLineNumber( 44 );
        DECREASE_REFCOUNT( CALL_FUNCTION_WITH_ARGS1( PyObjectTemporary( LOOKUP_ATTRIBUTE( PyObjectTemporary( LOOKUP_ATTRIBUTE( par_self.asObject0(), const_str_plain_surf ) ).asObject0(), const_str_plain_fill ) ).asObject0(), PyObjectTemporary( LIST_COPY( const_list_int_pos_255_int_0_int_pos_255_list ) ).asObject0() ) );
        frame_guard.setLineNumber( 45 );
        SET_ATTRIBUTE( const_int_0, GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_points );
        frame_guard.setLineNumber( 46 );
        SET_ATTRIBUTE( const_int_0, GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_hidden );
        frame_guard.setLineNumber( 47 );
        PyObjectTemporaryWithDel tmp_for_loop_1__for_iterator( MAKE_ITERATOR( PyObjectTemporary( CALL_FUNCTION( LOOKUP_BUILTIN( const_str_plain_sorted ), PyObjectTemporary( MAKE_TUPLE1( par_quads.asObject0() ) ).asObject0(), PyObjectTemporary( MAKE_DICT1( PyObjectTemporary( MAKE_FUNCTION_lambda_1_lambda_of_function_3_draw_of_class_1_SoftContext_of_module___main__(  ) ).asObject0(), const_str_plain_key ) ).asObject0() ) ).asObject0() ) );
        PythonExceptionKeeper _caught_1;
#if PYTHON_VERSION < 300
        int _at_lineno_1 = 0;
#endif


        try
        {
            // Tried block:
            while( true )
            {
                frame_guard.setLineNumber( 47 );
                PyObject *_tmp_unpack_2 = ITERATOR_NEXT( tmp_for_loop_1__for_iterator.asObject0() );

                if ( _tmp_unpack_2 == NULL )
                {
                    break;
                }
                tmp_for_loop_1__iter_value.assign1( _tmp_unpack_2 );
                var_q.assign0( tmp_for_loop_1__iter_value.asObject0() );
                frame_guard.setLineNumber( 48 );
                {
                    PyObjectTempKeeper0 call1;
                    PyObjectTempKeeper0 call2;
                    DECREASE_REFCOUNT( ( call1.assign( GET_MODULE_VALUE0( const_str_plain_draw_quad ) ), call2.assign( var_q.asObject0() ), CALL_FUNCTION_WITH_ARGS2( call1.asObject0(), call2.asObject0(), par_self.asObject0() ) ) );
                }

                CONSIDER_THREADING();
            }
        }
        catch ( PythonException &_exception )
        {
#if PYTHON_VERSION >= 300
            if ( !_exception.hasTraceback() )
            {
                _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
            }
            else
            {
                _exception.addTraceback( frame_guard.getFrame0() );
            }
#else
            _at_lineno_1 = frame_guard.getLineNumber();
#endif

            _caught_1.save( _exception );

#if PYTHON_VERSION >= 300
            frame_guard.preserveExistingException();

            _exception.toExceptionHandler();
#endif
        }

        // Final block:
        tmp_for_loop_1__iter_value.del( true );
        tmp_for_loop_1__for_iterator.del( false );
#if PYTHON_VERSION < 300
        if ( _at_lineno_1 != 0 )
        {
           frame_guard.setLineNumber( _at_lineno_1 );
        }
#endif
        _caught_1.rethrow();
        // Final end
        frame_guard.setLineNumber( 49 );
        {
            PyObjectTempKeeper1 call1;
            PyObjectTempKeeper1 call2;
            PyObjectTempKeeper1 make_list1;
            var_surf.assign1( ( call1.assign( LOOKUP_ATTRIBUTE( PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_transform ) ).asObject0(), const_str_plain_scale ) ), call2.assign( LOOKUP_ATTRIBUTE( par_self.asObject0(), const_str_plain_surf ) ), CALL_FUNCTION_WITH_ARGS2( call1.asObject0(), call2.asObject0(), PyObjectTemporary( ( make_list1.assign( LOOKUP_ATTRIBUTE( par_self.asObject0(), const_str_plain_r_w ) ), MAKE_LIST2( make_list1.asObject1(), LOOKUP_ATTRIBUTE( par_self.asObject0(), const_str_plain_r_h ) ) ) ).asObject0() ) ) );
        }
        frame_guard.setLineNumber( 50 );
        DECREASE_REFCOUNT( CALL_FUNCTION_WITH_ARGS1( PyObjectTemporary( LOOKUP_ATTRIBUTE( var_surf.asObject0(), const_str_plain_set_colorkey ) ).asObject0(), PyObjectTemporary( LIST_COPY( const_list_int_pos_255_int_0_int_pos_255_list ) ).asObject0() ) );
        frame_guard.setLineNumber( 51 );
        return var_surf.asObject1();
    }
    catch ( PythonException &_exception )
    {
        if ( !_exception.hasTraceback() )
        {
            _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
        }
        else
        {
            _exception.addTraceback( frame_guard.getFrame0() );
        }

        Py_XDECREF( frame_guard.getFrame0()->f_locals );
        frame_guard.getFrame0()->f_locals = par_quads.updateLocalsDict( par_self.updateLocalsDict( var_surf.updateLocalsDict( var_q.updateLocalsDict( PyDict_New() ) ) ) );

        if ( frame_guard.getFrame0() == frame_function_3_draw_of_class_1_SoftContext_of_module___main__ )
        {
           Py_DECREF( frame_function_3_draw_of_class_1_SoftContext_of_module___main__ );
           frame_function_3_draw_of_class_1_SoftContext_of_module___main__ = NULL;
        }

        _exception.toPython();
        return NULL;
    }

}
static PyObject *fparse_function_3_draw_of_class_1_SoftContext_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, Py_ssize_t args_size, PyObject *kw )
{
    assert( kw == NULL || PyDict_Check( kw ) );

    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_size = kw ? PyDict_Size( kw ) : 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_found = 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_only_found = 0;
    Py_ssize_t args_given = args_size;
    PyObject *_python_par_self = NULL;
    PyObject *_python_par_quads = NULL;
    // Copy given dictionary values to the the respective variables:
    if ( kw_size > 0 )
    {
        Py_ssize_t ppos = 0;
        PyObject *key, *value;

        while( PyDict_Next( kw, &ppos, &key, &value ) )
        {
#if PYTHON_VERSION < 300
            if (unlikely( !PyString_Check( key ) && !PyUnicode_Check( key ) ))
#else
            if (unlikely( !PyUnicode_Check( key ) ))
#endif
            {
                PyErr_Format( PyExc_TypeError, "draw() keywords must be strings" );
                goto error_exit;
            }

            NUITKA_MAY_BE_UNUSED bool found = false;

            Py_INCREF( key );
            Py_INCREF( value );

            // Quick path, could be our value.
            if ( found == false && const_str_plain_self == key )
            {
                assert( _python_par_self == NULL );
                _python_par_self = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_quads == key )
            {
                assert( _python_par_quads == NULL );
                _python_par_quads = value;

                found = true;
                kw_found += 1;
            }

            // Slow path, compare against all parameter names.
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_self, key ) )
            {
                assert( _python_par_self == NULL );
                _python_par_self = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_quads, key ) )
            {
                assert( _python_par_quads == NULL );
                _python_par_quads = value;

                found = true;
                kw_found += 1;
            }


            Py_DECREF( key );

            if ( found == false )
            {
               Py_DECREF( value );

               PyErr_Format(
                   PyExc_TypeError,
                   "draw() got an unexpected keyword argument '%s'",
                   Nuitka_String_Check( key ) ? Nuitka_String_AsString( key ) : "<non-string>"
               );

               goto error_exit;
            }
        }

#if PYTHON_VERSION < 300
        assert( kw_found == kw_size );
        assert( kw_only_found == 0 );
#endif
    }

    // Check if too many arguments were given in case of non star args
    if (unlikely( args_given > 2 ))
    {
#if PYTHON_VERSION < 270
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_size );
#elif PYTHON_VERSION < 330
        ERROR_TOO_MANY_ARGUMENTS( self, args_given + kw_found );
#else
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_only_found );
#endif
        goto error_exit;
    }


    // Copy normal parameter values given as part of the args list to the respective variables:

    if (likely( 0 < args_given ))
    {
         if (unlikely( _python_par_self != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 0 );
             goto error_exit;
         }

        _python_par_self = INCREASE_REFCOUNT( args[ 0 ] );
    }
    else if ( _python_par_self == NULL )
    {
        if ( 0 + self->m_defaults_given >= 2  )
        {
            _python_par_self = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 0 - 2 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 1 < args_given ))
    {
         if (unlikely( _python_par_quads != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 1 );
             goto error_exit;
         }

        _python_par_quads = INCREASE_REFCOUNT( args[ 1 ] );
    }
    else if ( _python_par_quads == NULL )
    {
        if ( 1 + self->m_defaults_given >= 2  )
        {
            _python_par_quads = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 1 - 2 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }

#if PYTHON_VERSION >= 330
    if (unlikely( _python_par_self == NULL || _python_par_quads == NULL ))
    {
        PyObject *values[] = { _python_par_self, _python_par_quads };
        ERROR_TOO_FEW_ARGUMENTS( self, values );

        goto error_exit;
    }
#endif


    return impl_function_3_draw_of_class_1_SoftContext_of_module___main__( self, _python_par_self, _python_par_quads );

error_exit:;

    Py_XDECREF( _python_par_self );
    Py_XDECREF( _python_par_quads );

    return NULL;
}

static PyObject *dparse_function_3_draw_of_class_1_SoftContext_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, int size )
{
    if ( size == 2 )
    {
        return impl_function_3_draw_of_class_1_SoftContext_of_module___main__( self, INCREASE_REFCOUNT( args[ 0 ] ), INCREASE_REFCOUNT( args[ 1 ] ) );
    }
    else
    {
        PyObject *result = fparse_function_3_draw_of_class_1_SoftContext_of_module___main__( self, args, size, NULL );
        return result;
    }

}



static PyObject *impl_lambda_1_lambda_of_function_3_draw_of_class_1_SoftContext_of_module___main__( Nuitka_FunctionObject *self, PyObject *_python_par_q )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par_q( const_str_plain_q, _python_par_q );

    // Actual function code.
    static PyFrameObject *frame_lambda_1_lambda_of_function_3_draw_of_class_1_SoftContext_of_module___main__ = NULL;

    if ( isFrameUnusable( frame_lambda_1_lambda_of_function_3_draw_of_class_1_SoftContext_of_module___main__ ) )
    {
        if ( frame_lambda_1_lambda_of_function_3_draw_of_class_1_SoftContext_of_module___main__ )
        {
#if _DEBUG_REFRAME
            puts( "reframe for lambda_1_lambda_of_function_3_draw_of_class_1_SoftContext_of_module___main__" );
#endif
            Py_DECREF( frame_lambda_1_lambda_of_function_3_draw_of_class_1_SoftContext_of_module___main__ );
        }

        frame_lambda_1_lambda_of_function_3_draw_of_class_1_SoftContext_of_module___main__ = MAKE_FRAME( codeobj_f679d2f49ece2d6f8edfb3d70295f3ef, module___main__ );
    }

    FrameGuard frame_guard( frame_lambda_1_lambda_of_function_3_draw_of_class_1_SoftContext_of_module___main__ );
    try
    {
        assert( Py_REFCNT( frame_lambda_1_lambda_of_function_3_draw_of_class_1_SoftContext_of_module___main__ ) == 2 ); // Frame stack
        frame_guard.setLineNumber( 47 );
        return LOOKUP_SUBSCRIPT_CONST( PyObjectTemporary( LOOKUP_ATTRIBUTE( par_q.asObject0(), const_str_plain_points ) ).asObject0(), const_int_pos_2, 2 );
    }
    catch ( PythonException &_exception )
    {
        if ( !_exception.hasTraceback() )
        {
            _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
        }
        else
        {
            _exception.addTraceback( frame_guard.getFrame0() );
        }

        Py_XDECREF( frame_guard.getFrame0()->f_locals );
        frame_guard.getFrame0()->f_locals = par_q.updateLocalsDict( PyDict_New() );

        if ( frame_guard.getFrame0() == frame_lambda_1_lambda_of_function_3_draw_of_class_1_SoftContext_of_module___main__ )
        {
           Py_DECREF( frame_lambda_1_lambda_of_function_3_draw_of_class_1_SoftContext_of_module___main__ );
           frame_lambda_1_lambda_of_function_3_draw_of_class_1_SoftContext_of_module___main__ = NULL;
        }

        _exception.toPython();
        return NULL;
    }

}
static PyObject *fparse_lambda_1_lambda_of_function_3_draw_of_class_1_SoftContext_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, Py_ssize_t args_size, PyObject *kw )
{
    assert( kw == NULL || PyDict_Check( kw ) );

    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_size = kw ? PyDict_Size( kw ) : 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_found = 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_only_found = 0;
    Py_ssize_t args_given = args_size;
    PyObject *_python_par_q = NULL;
    // Copy given dictionary values to the the respective variables:
    if ( kw_size > 0 )
    {
        Py_ssize_t ppos = 0;
        PyObject *key, *value;

        while( PyDict_Next( kw, &ppos, &key, &value ) )
        {
#if PYTHON_VERSION < 300
            if (unlikely( !PyString_Check( key ) && !PyUnicode_Check( key ) ))
#else
            if (unlikely( !PyUnicode_Check( key ) ))
#endif
            {
                PyErr_Format( PyExc_TypeError, "<lambda>() keywords must be strings" );
                goto error_exit;
            }

            NUITKA_MAY_BE_UNUSED bool found = false;

            Py_INCREF( key );
            Py_INCREF( value );

            // Quick path, could be our value.
            if ( found == false && const_str_plain_q == key )
            {
                assert( _python_par_q == NULL );
                _python_par_q = value;

                found = true;
                kw_found += 1;
            }

            // Slow path, compare against all parameter names.
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_q, key ) )
            {
                assert( _python_par_q == NULL );
                _python_par_q = value;

                found = true;
                kw_found += 1;
            }


            Py_DECREF( key );

            if ( found == false )
            {
               Py_DECREF( value );

               PyErr_Format(
                   PyExc_TypeError,
                   "<lambda>() got an unexpected keyword argument '%s'",
                   Nuitka_String_Check( key ) ? Nuitka_String_AsString( key ) : "<non-string>"
               );

               goto error_exit;
            }
        }

#if PYTHON_VERSION < 300
        assert( kw_found == kw_size );
        assert( kw_only_found == 0 );
#endif
    }

    // Check if too many arguments were given in case of non star args
    if (unlikely( args_given > 1 ))
    {
#if PYTHON_VERSION < 270
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_size );
#elif PYTHON_VERSION < 330
        ERROR_TOO_MANY_ARGUMENTS( self, args_given + kw_found );
#else
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_only_found );
#endif
        goto error_exit;
    }


    // Copy normal parameter values given as part of the args list to the respective variables:

    if (likely( 0 < args_given ))
    {
         if (unlikely( _python_par_q != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 0 );
             goto error_exit;
         }

        _python_par_q = INCREASE_REFCOUNT( args[ 0 ] );
    }
    else if ( _python_par_q == NULL )
    {
        if ( 0 + self->m_defaults_given >= 1  )
        {
            _python_par_q = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 0 - 1 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }

#if PYTHON_VERSION >= 330
    if (unlikely( _python_par_q == NULL ))
    {
        PyObject *values[] = { _python_par_q };
        ERROR_TOO_FEW_ARGUMENTS( self, values );

        goto error_exit;
    }
#endif


    return impl_lambda_1_lambda_of_function_3_draw_of_class_1_SoftContext_of_module___main__( self, _python_par_q );

error_exit:;

    Py_XDECREF( _python_par_q );

    return NULL;
}

static PyObject *dparse_lambda_1_lambda_of_function_3_draw_of_class_1_SoftContext_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, int size )
{
    if ( size == 1 )
    {
        return impl_lambda_1_lambda_of_function_3_draw_of_class_1_SoftContext_of_module___main__( self, INCREASE_REFCOUNT( args[ 0 ] ) );
    }
    else
    {
        PyObject *result = fparse_lambda_1_lambda_of_function_3_draw_of_class_1_SoftContext_of_module___main__( self, args, size, NULL );
        return result;
    }

}



static PyObject *impl_function_2_load_tex_of_module___main__( Nuitka_FunctionObject *self, PyObject *_python_par_img )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par_img( const_str_plain_img, _python_par_img );
    PyObjectLocalVariable var_tex( const_str_plain_tex );
    PyObjectLocalVariable var_texarr( const_str_plain_texarr );
    PyObjectLocalVariable var_mem( const_str_plain_mem );
    PyObjectLocalVariable var_alpha( const_str_plain_alpha );
    PyObjectLocalVariable var_z( const_str_plain_z );
    PyObjectLocalVariable var_blank( const_str_plain_blank );
    PyObjectLocalVariable var_arr( const_str_plain_arr );
    PyObjectLocalVariable var_tw( const_str_plain_tw );
    PyObjectLocalVariable var_th( const_str_plain_th );
    PyObjectTempVariable tmp_for_loop_1__iter_value;

    // Actual function code.
    static PyFrameObject *frame_function_2_load_tex_of_module___main__ = NULL;

    if ( isFrameUnusable( frame_function_2_load_tex_of_module___main__ ) )
    {
        if ( frame_function_2_load_tex_of_module___main__ )
        {
#if _DEBUG_REFRAME
            puts( "reframe for function_2_load_tex_of_module___main__" );
#endif
            Py_DECREF( frame_function_2_load_tex_of_module___main__ );
        }

        frame_function_2_load_tex_of_module___main__ = MAKE_FRAME( codeobj_6fb1791102effc565fd9c310f87ad8b2, module___main__ );
    }

    FrameGuard frame_guard( frame_function_2_load_tex_of_module___main__ );
    try
    {
        assert( Py_REFCNT( frame_function_2_load_tex_of_module___main__ ) == 2 ); // Frame stack
        frame_guard.setLineNumber( 60 );
        {
            PyObjectTempKeeper1 call1;
            PyObjectTempKeeper1 call2;
            var_tex.assign1( ( call2.assign( LOOKUP_ATTRIBUTE( PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_transform ) ).asObject0(), const_str_plain_flip ) ), CALL_FUNCTION_WITH_ARGS3( call2.asObject0(), PyObjectTemporary( ( call1.assign( LOOKUP_ATTRIBUTE( PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_image ) ).asObject0(), const_str_plain_load ) ), CALL_FUNCTION_WITH_ARGS1( call1.asObject0(), par_img.asObject0() ) ) ).asObject0(), const_int_0, const_int_pos_1 ) ) );
        }
        var_texarr.assign1( PyList_New( 0 ) );
        var_mem.assign1( PyList_New( 0 ) );
        var_alpha.assign0( const_int_pos_255 );
        frame_guard.setLineNumber( 65 );
        PyObjectTemporaryWithDel tmp_for_loop_1__for_iterator( MAKE_ITERATOR( const_tuple_f574c86ffc3b1d2f77c150b7cab373d2_tuple ) );
        PythonExceptionKeeper _caught_1;
#if PYTHON_VERSION < 300
        int _at_lineno_1 = 0;
#endif


        try
        {
            // Tried block:
            while( true )
            {
                frame_guard.setLineNumber( 65 );
                PyObject *_tmp_unpack_2 = ITERATOR_NEXT( tmp_for_loop_1__for_iterator.asObject0() );

                if ( _tmp_unpack_2 == NULL )
                {
                    break;
                }
                tmp_for_loop_1__iter_value.assign1( _tmp_unpack_2 );
                var_z.assign0( tmp_for_loop_1__iter_value.asObject0() );
                frame_guard.setLineNumber( 66 );
                var_blank.assign1( CALL_FUNCTION_NO_ARGS( PyObjectTemporary( LOOKUP_ATTRIBUTE( var_tex.asObject0(), const_str_plain_convert ) ).asObject0() ) );
                frame_guard.setLineNumber( 67 );
                DECREASE_REFCOUNT( CALL_FUNCTION_WITH_ARGS1( PyObjectTemporary( LOOKUP_ATTRIBUTE( var_blank.asObject0(), const_str_plain_fill ) ).asObject0(), PyObjectTemporary( LIST_COPY( const_list_int_0_int_0_int_0_list ) ).asObject0() ) );
                frame_guard.setLineNumber( 68 );
                {
                    PyObjectTempKeeper1 call1;
                    DECREASE_REFCOUNT( ( call1.assign( LOOKUP_ATTRIBUTE( var_tex.asObject0(), const_str_plain_set_alpha ) ), CALL_FUNCTION_WITH_ARGS1( call1.asObject0(), var_alpha.asObject0() ) ) );
                }
                frame_guard.setLineNumber( 69 );
                {
                    PyObjectTempKeeper1 call1;
                    DECREASE_REFCOUNT( ( call1.assign( LOOKUP_ATTRIBUTE( var_blank.asObject0(), const_str_plain_blit ) ), CALL_FUNCTION_WITH_ARGS2( call1.asObject0(), var_tex.asObject0(), PyObjectTemporary( LIST_COPY( const_list_int_0_int_0_list ) ).asObject0() ) ) );
                }
                frame_guard.setLineNumber( 70 );
                var_alpha.assign1( TO_INT( PyObjectTemporary( BINARY_OPERATION_MUL( const_float_0_8, var_alpha.asObject0() ) ).asObject0() ) );
                frame_guard.setLineNumber( 71 );
                {
                    PyObjectTempKeeper1 call1;
                    var_arr.assign1( ( call1.assign( LOOKUP_ATTRIBUTE( PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_surfarray ) ).asObject0(), const_str_plain_array2d ) ), CALL_FUNCTION_WITH_ARGS1( call1.asObject0(), var_blank.asObject0() ) ) );
                }
                frame_guard.setLineNumber( 72 );
                {
                    PyObjectTempKeeper1 call1;
                    DECREASE_REFCOUNT( ( call1.assign( LOOKUP_ATTRIBUTE( var_texarr.asObject0(), const_str_plain_append ) ), CALL_FUNCTION_WITH_ARGS1( call1.asObject0(), var_arr.asObject0() ) ) );
                }
                frame_guard.setLineNumber( 73 );
                {
                    PyObjectTempKeeper1 call1;
                    DECREASE_REFCOUNT( ( call1.assign( LOOKUP_ATTRIBUTE( var_mem.asObject0(), const_str_plain_append ) ), CALL_FUNCTION_WITH_ARGS1( call1.asObject0(), var_blank.asObject0() ) ) );
                }

                CONSIDER_THREADING();
            }
        }
        catch ( PythonException &_exception )
        {
#if PYTHON_VERSION >= 300
            if ( !_exception.hasTraceback() )
            {
                _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
            }
            else
            {
                _exception.addTraceback( frame_guard.getFrame0() );
            }
#else
            _at_lineno_1 = frame_guard.getLineNumber();
#endif

            _caught_1.save( _exception );

#if PYTHON_VERSION >= 300
            frame_guard.preserveExistingException();

            _exception.toExceptionHandler();
#endif
        }

        // Final block:
        tmp_for_loop_1__iter_value.del( true );
        tmp_for_loop_1__for_iterator.del( false );
#if PYTHON_VERSION < 300
        if ( _at_lineno_1 != 0 )
        {
           frame_guard.setLineNumber( _at_lineno_1 );
        }
#endif
        _caught_1.rethrow();
        // Final end
        frame_guard.setLineNumber( 74 );
        var_tw.assign1( BINARY_OPERATION_SUB( PyObjectTemporary( CALL_FUNCTION_NO_ARGS( PyObjectTemporary( LOOKUP_ATTRIBUTE( var_tex.asObject0(), const_str_plain_get_width ) ).asObject0() ) ).asObject0(), const_int_pos_1 ) );
        frame_guard.setLineNumber( 75 );
        var_th.assign1( BINARY_OPERATION_SUB( PyObjectTemporary( CALL_FUNCTION_NO_ARGS( PyObjectTemporary( LOOKUP_ATTRIBUTE( var_tex.asObject0(), const_str_plain_get_height ) ).asObject0() ) ).asObject0(), const_int_pos_1 ) );
        frame_guard.setLineNumber( 76 );
        {
            PyObjectTempKeeper0 make_tuple1;
            PyObjectTempKeeper0 make_tuple2;
            return ( make_tuple1.assign( var_texarr.asObject0() ), make_tuple2.assign( var_tw.asObject0() ), MAKE_TUPLE3( make_tuple1.asObject0(), make_tuple2.asObject0(), var_th.asObject0() ) );
        }
    }
    catch ( PythonException &_exception )
    {
        if ( !_exception.hasTraceback() )
        {
            _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
        }
        else
        {
            _exception.addTraceback( frame_guard.getFrame0() );
        }

        Py_XDECREF( frame_guard.getFrame0()->f_locals );
        frame_guard.getFrame0()->f_locals = par_img.updateLocalsDict( var_th.updateLocalsDict( var_tw.updateLocalsDict( var_arr.updateLocalsDict( var_blank.updateLocalsDict( var_z.updateLocalsDict( var_alpha.updateLocalsDict( var_mem.updateLocalsDict( var_texarr.updateLocalsDict( var_tex.updateLocalsDict( PyDict_New() ) ) ) ) ) ) ) ) ) );

        if ( frame_guard.getFrame0() == frame_function_2_load_tex_of_module___main__ )
        {
           Py_DECREF( frame_function_2_load_tex_of_module___main__ );
           frame_function_2_load_tex_of_module___main__ = NULL;
        }

        _exception.toPython();
        return NULL;
    }

}
static PyObject *fparse_function_2_load_tex_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, Py_ssize_t args_size, PyObject *kw )
{
    assert( kw == NULL || PyDict_Check( kw ) );

    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_size = kw ? PyDict_Size( kw ) : 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_found = 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_only_found = 0;
    Py_ssize_t args_given = args_size;
    PyObject *_python_par_img = NULL;
    // Copy given dictionary values to the the respective variables:
    if ( kw_size > 0 )
    {
        Py_ssize_t ppos = 0;
        PyObject *key, *value;

        while( PyDict_Next( kw, &ppos, &key, &value ) )
        {
#if PYTHON_VERSION < 300
            if (unlikely( !PyString_Check( key ) && !PyUnicode_Check( key ) ))
#else
            if (unlikely( !PyUnicode_Check( key ) ))
#endif
            {
                PyErr_Format( PyExc_TypeError, "load_tex() keywords must be strings" );
                goto error_exit;
            }

            NUITKA_MAY_BE_UNUSED bool found = false;

            Py_INCREF( key );
            Py_INCREF( value );

            // Quick path, could be our value.
            if ( found == false && const_str_plain_img == key )
            {
                assert( _python_par_img == NULL );
                _python_par_img = value;

                found = true;
                kw_found += 1;
            }

            // Slow path, compare against all parameter names.
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_img, key ) )
            {
                assert( _python_par_img == NULL );
                _python_par_img = value;

                found = true;
                kw_found += 1;
            }


            Py_DECREF( key );

            if ( found == false )
            {
               Py_DECREF( value );

               PyErr_Format(
                   PyExc_TypeError,
                   "load_tex() got an unexpected keyword argument '%s'",
                   Nuitka_String_Check( key ) ? Nuitka_String_AsString( key ) : "<non-string>"
               );

               goto error_exit;
            }
        }

#if PYTHON_VERSION < 300
        assert( kw_found == kw_size );
        assert( kw_only_found == 0 );
#endif
    }

    // Check if too many arguments were given in case of non star args
    if (unlikely( args_given > 1 ))
    {
#if PYTHON_VERSION < 270
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_size );
#elif PYTHON_VERSION < 330
        ERROR_TOO_MANY_ARGUMENTS( self, args_given + kw_found );
#else
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_only_found );
#endif
        goto error_exit;
    }


    // Copy normal parameter values given as part of the args list to the respective variables:

    if (likely( 0 < args_given ))
    {
         if (unlikely( _python_par_img != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 0 );
             goto error_exit;
         }

        _python_par_img = INCREASE_REFCOUNT( args[ 0 ] );
    }
    else if ( _python_par_img == NULL )
    {
        if ( 0 + self->m_defaults_given >= 1  )
        {
            _python_par_img = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 0 - 1 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }

#if PYTHON_VERSION >= 330
    if (unlikely( _python_par_img == NULL ))
    {
        PyObject *values[] = { _python_par_img };
        ERROR_TOO_FEW_ARGUMENTS( self, values );

        goto error_exit;
    }
#endif


    return impl_function_2_load_tex_of_module___main__( self, _python_par_img );

error_exit:;

    Py_XDECREF( _python_par_img );

    return NULL;
}

static PyObject *dparse_function_2_load_tex_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, int size )
{
    if ( size == 1 )
    {
        return impl_function_2_load_tex_of_module___main__( self, INCREASE_REFCOUNT( args[ 0 ] ) );
    }
    else
    {
        PyObject *result = fparse_function_2_load_tex_of_module___main__( self, args, size, NULL );
        return result;
    }

}



static PyObject *impl_function_3_trans_of_module___main__( Nuitka_FunctionObject *self, PyObject *_python_par_q, PyObject *_python_par_x, PyObject *_python_par_y, PyObject *_python_par_z )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par_q( const_str_plain_q, _python_par_q );
    PyObjectLocalParameterVariableNoDel par_x( const_str_plain_x, _python_par_x );
    PyObjectLocalParameterVariableNoDel par_y( const_str_plain_y, _python_par_y );
    PyObjectLocalParameterVariableNoDel par_z( const_str_plain_z, _python_par_z );
    PyObjectLocalVariable var_p( const_str_plain_p );
    PyObjectTempVariable tmp_for_loop_1__iter_value;

    // Actual function code.
    static PyFrameObject *frame_function_3_trans_of_module___main__ = NULL;

    if ( isFrameUnusable( frame_function_3_trans_of_module___main__ ) )
    {
        if ( frame_function_3_trans_of_module___main__ )
        {
#if _DEBUG_REFRAME
            puts( "reframe for function_3_trans_of_module___main__" );
#endif
            Py_DECREF( frame_function_3_trans_of_module___main__ );
        }

        frame_function_3_trans_of_module___main__ = MAKE_FRAME( codeobj_46d68a7653dbb9da948e90fdfae109f8, module___main__ );
    }

    FrameGuard frame_guard( frame_function_3_trans_of_module___main__ );
    try
    {
        assert( Py_REFCNT( frame_function_3_trans_of_module___main__ ) == 2 ); // Frame stack
        frame_guard.setLineNumber( 79 );
        PyObjectTemporaryWithDel tmp_for_loop_1__for_iterator( MAKE_ITERATOR( PyObjectTemporary( LOOKUP_INDEX_SLICE( PyObjectTemporary( LOOKUP_ATTRIBUTE( par_q.asObject0(), const_str_plain_points ) ).asObject0(), 0, 4 ) ).asObject0() ) );
        PythonExceptionKeeper _caught_1;
#if PYTHON_VERSION < 300
        int _at_lineno_1 = 0;
#endif


        try
        {
            // Tried block:
            while( true )
            {
                frame_guard.setLineNumber( 79 );
                PyObject *_tmp_unpack_2 = ITERATOR_NEXT( tmp_for_loop_1__for_iterator.asObject0() );

                if ( _tmp_unpack_2 == NULL )
                {
                    break;
                }
                tmp_for_loop_1__iter_value.assign1( _tmp_unpack_2 );
                var_p.assign0( tmp_for_loop_1__iter_value.asObject0() );
                frame_guard.setLineNumber( 80 );
                PyObject *tmp_inplace_assign_1__inplace_target = var_p.asObject0();
                PyObject *tmp_inplace_assign_1__inplace_subscript = const_int_0;
                {
                    PyObjectTempKeeper1 op1;
                    PyObjectTempKeeper0 subscr1;
                    {
                        PyObjectTemporary tmp_identifier( ( op1.assign( ( subscr1.assign( tmp_inplace_assign_1__inplace_target ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), tmp_inplace_assign_1__inplace_subscript ) ) ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), par_x.asObject0() ) ) );
                        PyObject *tmp_subscribed = tmp_inplace_assign_1__inplace_target;
                        SET_SUBSCRIPT( tmp_identifier.asObject0(), tmp_subscribed, tmp_inplace_assign_1__inplace_subscript );
                    }
                }
                frame_guard.setLineNumber( 81 );
                PyObject *tmp_inplace_assign_2__inplace_target = var_p.asObject0();
                PyObject *tmp_inplace_assign_2__inplace_subscript = const_int_pos_1;
                {
                    PyObjectTempKeeper1 op1;
                    PyObjectTempKeeper0 subscr1;
                    {
                        PyObjectTemporary tmp_identifier( ( op1.assign( ( subscr1.assign( tmp_inplace_assign_2__inplace_target ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), tmp_inplace_assign_2__inplace_subscript ) ) ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), par_y.asObject0() ) ) );
                        PyObject *tmp_subscribed = tmp_inplace_assign_2__inplace_target;
                        SET_SUBSCRIPT( tmp_identifier.asObject0(), tmp_subscribed, tmp_inplace_assign_2__inplace_subscript );
                    }
                }
                frame_guard.setLineNumber( 82 );
                PyObject *tmp_inplace_assign_3__inplace_target = var_p.asObject0();
                PyObject *tmp_inplace_assign_3__inplace_subscript = const_int_pos_2;
                {
                    PyObjectTempKeeper1 op1;
                    PyObjectTempKeeper0 subscr1;
                    {
                        PyObjectTemporary tmp_identifier( ( op1.assign( ( subscr1.assign( tmp_inplace_assign_3__inplace_target ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), tmp_inplace_assign_3__inplace_subscript ) ) ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), par_z.asObject0() ) ) );
                        PyObject *tmp_subscribed = tmp_inplace_assign_3__inplace_target;
                        SET_SUBSCRIPT( tmp_identifier.asObject0(), tmp_subscribed, tmp_inplace_assign_3__inplace_subscript );
                    }
                }

                CONSIDER_THREADING();
            }
        }
        catch ( PythonException &_exception )
        {
#if PYTHON_VERSION >= 300
            if ( !_exception.hasTraceback() )
            {
                _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
            }
            else
            {
                _exception.addTraceback( frame_guard.getFrame0() );
            }
#else
            _at_lineno_1 = frame_guard.getLineNumber();
#endif

            _caught_1.save( _exception );

#if PYTHON_VERSION >= 300
            frame_guard.preserveExistingException();

            _exception.toExceptionHandler();
#endif
        }

        // Final block:
        tmp_for_loop_1__iter_value.del( true );
        tmp_for_loop_1__for_iterator.del( false );
#if PYTHON_VERSION < 300
        if ( _at_lineno_1 != 0 )
        {
           frame_guard.setLineNumber( _at_lineno_1 );
        }
#endif
        _caught_1.rethrow();
        // Final end
    }
    catch ( PythonException &_exception )
    {
        if ( !_exception.hasTraceback() )
        {
            _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
        }
        else
        {
            _exception.addTraceback( frame_guard.getFrame0() );
        }

        Py_XDECREF( frame_guard.getFrame0()->f_locals );
        frame_guard.getFrame0()->f_locals = par_z.updateLocalsDict( par_y.updateLocalsDict( par_x.updateLocalsDict( par_q.updateLocalsDict( var_p.updateLocalsDict( PyDict_New() ) ) ) ) );

        if ( frame_guard.getFrame0() == frame_function_3_trans_of_module___main__ )
        {
           Py_DECREF( frame_function_3_trans_of_module___main__ );
           frame_function_3_trans_of_module___main__ = NULL;
        }

        _exception.toPython();
        return NULL;
    }
    return INCREASE_REFCOUNT( Py_None );
}
static PyObject *fparse_function_3_trans_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, Py_ssize_t args_size, PyObject *kw )
{
    assert( kw == NULL || PyDict_Check( kw ) );

    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_size = kw ? PyDict_Size( kw ) : 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_found = 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_only_found = 0;
    Py_ssize_t args_given = args_size;
    PyObject *_python_par_q = NULL;
    PyObject *_python_par_x = NULL;
    PyObject *_python_par_y = NULL;
    PyObject *_python_par_z = NULL;
    // Copy given dictionary values to the the respective variables:
    if ( kw_size > 0 )
    {
        Py_ssize_t ppos = 0;
        PyObject *key, *value;

        while( PyDict_Next( kw, &ppos, &key, &value ) )
        {
#if PYTHON_VERSION < 300
            if (unlikely( !PyString_Check( key ) && !PyUnicode_Check( key ) ))
#else
            if (unlikely( !PyUnicode_Check( key ) ))
#endif
            {
                PyErr_Format( PyExc_TypeError, "trans() keywords must be strings" );
                goto error_exit;
            }

            NUITKA_MAY_BE_UNUSED bool found = false;

            Py_INCREF( key );
            Py_INCREF( value );

            // Quick path, could be our value.
            if ( found == false && const_str_plain_q == key )
            {
                assert( _python_par_q == NULL );
                _python_par_q = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_x == key )
            {
                assert( _python_par_x == NULL );
                _python_par_x = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_y == key )
            {
                assert( _python_par_y == NULL );
                _python_par_y = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_z == key )
            {
                assert( _python_par_z == NULL );
                _python_par_z = value;

                found = true;
                kw_found += 1;
            }

            // Slow path, compare against all parameter names.
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_q, key ) )
            {
                assert( _python_par_q == NULL );
                _python_par_q = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_x, key ) )
            {
                assert( _python_par_x == NULL );
                _python_par_x = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_y, key ) )
            {
                assert( _python_par_y == NULL );
                _python_par_y = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_z, key ) )
            {
                assert( _python_par_z == NULL );
                _python_par_z = value;

                found = true;
                kw_found += 1;
            }


            Py_DECREF( key );

            if ( found == false )
            {
               Py_DECREF( value );

               PyErr_Format(
                   PyExc_TypeError,
                   "trans() got an unexpected keyword argument '%s'",
                   Nuitka_String_Check( key ) ? Nuitka_String_AsString( key ) : "<non-string>"
               );

               goto error_exit;
            }
        }

#if PYTHON_VERSION < 300
        assert( kw_found == kw_size );
        assert( kw_only_found == 0 );
#endif
    }

    // Check if too many arguments were given in case of non star args
    if (unlikely( args_given > 4 ))
    {
#if PYTHON_VERSION < 270
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_size );
#elif PYTHON_VERSION < 330
        ERROR_TOO_MANY_ARGUMENTS( self, args_given + kw_found );
#else
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_only_found );
#endif
        goto error_exit;
    }


    // Copy normal parameter values given as part of the args list to the respective variables:

    if (likely( 0 < args_given ))
    {
         if (unlikely( _python_par_q != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 0 );
             goto error_exit;
         }

        _python_par_q = INCREASE_REFCOUNT( args[ 0 ] );
    }
    else if ( _python_par_q == NULL )
    {
        if ( 0 + self->m_defaults_given >= 4  )
        {
            _python_par_q = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 0 - 4 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 1 < args_given ))
    {
         if (unlikely( _python_par_x != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 1 );
             goto error_exit;
         }

        _python_par_x = INCREASE_REFCOUNT( args[ 1 ] );
    }
    else if ( _python_par_x == NULL )
    {
        if ( 1 + self->m_defaults_given >= 4  )
        {
            _python_par_x = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 1 - 4 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 2 < args_given ))
    {
         if (unlikely( _python_par_y != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 2 );
             goto error_exit;
         }

        _python_par_y = INCREASE_REFCOUNT( args[ 2 ] );
    }
    else if ( _python_par_y == NULL )
    {
        if ( 2 + self->m_defaults_given >= 4  )
        {
            _python_par_y = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 2 - 4 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 3 < args_given ))
    {
         if (unlikely( _python_par_z != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 3 );
             goto error_exit;
         }

        _python_par_z = INCREASE_REFCOUNT( args[ 3 ] );
    }
    else if ( _python_par_z == NULL )
    {
        if ( 3 + self->m_defaults_given >= 4  )
        {
            _python_par_z = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 3 - 4 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }

#if PYTHON_VERSION >= 330
    if (unlikely( _python_par_q == NULL || _python_par_x == NULL || _python_par_y == NULL || _python_par_z == NULL ))
    {
        PyObject *values[] = { _python_par_q, _python_par_x, _python_par_y, _python_par_z };
        ERROR_TOO_FEW_ARGUMENTS( self, values );

        goto error_exit;
    }
#endif


    return impl_function_3_trans_of_module___main__( self, _python_par_q, _python_par_x, _python_par_y, _python_par_z );

error_exit:;

    Py_XDECREF( _python_par_q );
    Py_XDECREF( _python_par_x );
    Py_XDECREF( _python_par_y );
    Py_XDECREF( _python_par_z );

    return NULL;
}

static PyObject *dparse_function_3_trans_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, int size )
{
    if ( size == 4 )
    {
        return impl_function_3_trans_of_module___main__( self, INCREASE_REFCOUNT( args[ 0 ] ), INCREASE_REFCOUNT( args[ 1 ] ), INCREASE_REFCOUNT( args[ 2 ] ), INCREASE_REFCOUNT( args[ 3 ] ) );
    }
    else
    {
        PyObject *result = fparse_function_3_trans_of_module___main__( self, args, size, NULL );
        return result;
    }

}



static PyObject *impl_function_4_push_of_module___main__( Nuitka_FunctionObject *self, PyObject *_python_par_q, PyObject *_python_par_z )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par_q( const_str_plain_q, _python_par_q );
    PyObjectLocalParameterVariableNoDel par_z( const_str_plain_z, _python_par_z );

    // Actual function code.
    static PyFrameObject *frame_function_4_push_of_module___main__ = NULL;

    if ( isFrameUnusable( frame_function_4_push_of_module___main__ ) )
    {
        if ( frame_function_4_push_of_module___main__ )
        {
#if _DEBUG_REFRAME
            puts( "reframe for function_4_push_of_module___main__" );
#endif
            Py_DECREF( frame_function_4_push_of_module___main__ );
        }

        frame_function_4_push_of_module___main__ = MAKE_FRAME( codeobj_50e8ec0c7dd41646e9e953668d8ae96d, module___main__ );
    }

    FrameGuard frame_guard( frame_function_4_push_of_module___main__ );
    try
    {
        assert( Py_REFCNT( frame_function_4_push_of_module___main__ ) == 2 ); // Frame stack
        frame_guard.setLineNumber( 84 );
        PyObjectTemporary tmp_inplace_assign_1__inplace_target( LOOKUP_SUBSCRIPT_CONST( PyObjectTemporary( LOOKUP_ATTRIBUTE( par_q.asObject0(), const_str_plain_points ) ).asObject0(), const_int_0, 0 ) );
        PyObject *tmp_inplace_assign_1__inplace_subscript = const_int_pos_2;
        {
            PyObjectTempKeeper1 op1;
            PyObjectTempKeeper0 subscr1;
            {
                PyObjectTemporary tmp_identifier( ( op1.assign( ( subscr1.assign( tmp_inplace_assign_1__inplace_target.asObject0() ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), tmp_inplace_assign_1__inplace_subscript ) ) ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), par_z.asObject0() ) ) );
                PyObject *tmp_subscribed = tmp_inplace_assign_1__inplace_target.asObject0();
                SET_SUBSCRIPT( tmp_identifier.asObject0(), tmp_subscribed, tmp_inplace_assign_1__inplace_subscript );
            }
        }
        frame_guard.setLineNumber( 85 );
        PyObjectTemporary tmp_inplace_assign_2__inplace_target( LOOKUP_SUBSCRIPT_CONST( PyObjectTemporary( LOOKUP_ATTRIBUTE( par_q.asObject0(), const_str_plain_points ) ).asObject0(), const_int_pos_3, 3 ) );
        PyObject *tmp_inplace_assign_2__inplace_subscript = const_int_pos_2;
        {
            PyObjectTempKeeper1 op1;
            PyObjectTempKeeper0 subscr1;
            {
                PyObjectTemporary tmp_identifier( ( op1.assign( ( subscr1.assign( tmp_inplace_assign_2__inplace_target.asObject0() ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), tmp_inplace_assign_2__inplace_subscript ) ) ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), par_z.asObject0() ) ) );
                PyObject *tmp_subscribed = tmp_inplace_assign_2__inplace_target.asObject0();
                SET_SUBSCRIPT( tmp_identifier.asObject0(), tmp_subscribed, tmp_inplace_assign_2__inplace_subscript );
            }
        }
    }
    catch ( PythonException &_exception )
    {
        if ( !_exception.hasTraceback() )
        {
            _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
        }
        else
        {
            _exception.addTraceback( frame_guard.getFrame0() );
        }

        Py_XDECREF( frame_guard.getFrame0()->f_locals );
        frame_guard.getFrame0()->f_locals = par_z.updateLocalsDict( par_q.updateLocalsDict( PyDict_New() ) );

        if ( frame_guard.getFrame0() == frame_function_4_push_of_module___main__ )
        {
           Py_DECREF( frame_function_4_push_of_module___main__ );
           frame_function_4_push_of_module___main__ = NULL;
        }

        _exception.toPython();
        return NULL;
    }
    return INCREASE_REFCOUNT( Py_None );
}
static PyObject *fparse_function_4_push_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, Py_ssize_t args_size, PyObject *kw )
{
    assert( kw == NULL || PyDict_Check( kw ) );

    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_size = kw ? PyDict_Size( kw ) : 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_found = 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_only_found = 0;
    Py_ssize_t args_given = args_size;
    PyObject *_python_par_q = NULL;
    PyObject *_python_par_z = NULL;
    // Copy given dictionary values to the the respective variables:
    if ( kw_size > 0 )
    {
        Py_ssize_t ppos = 0;
        PyObject *key, *value;

        while( PyDict_Next( kw, &ppos, &key, &value ) )
        {
#if PYTHON_VERSION < 300
            if (unlikely( !PyString_Check( key ) && !PyUnicode_Check( key ) ))
#else
            if (unlikely( !PyUnicode_Check( key ) ))
#endif
            {
                PyErr_Format( PyExc_TypeError, "push() keywords must be strings" );
                goto error_exit;
            }

            NUITKA_MAY_BE_UNUSED bool found = false;

            Py_INCREF( key );
            Py_INCREF( value );

            // Quick path, could be our value.
            if ( found == false && const_str_plain_q == key )
            {
                assert( _python_par_q == NULL );
                _python_par_q = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_z == key )
            {
                assert( _python_par_z == NULL );
                _python_par_z = value;

                found = true;
                kw_found += 1;
            }

            // Slow path, compare against all parameter names.
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_q, key ) )
            {
                assert( _python_par_q == NULL );
                _python_par_q = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_z, key ) )
            {
                assert( _python_par_z == NULL );
                _python_par_z = value;

                found = true;
                kw_found += 1;
            }


            Py_DECREF( key );

            if ( found == false )
            {
               Py_DECREF( value );

               PyErr_Format(
                   PyExc_TypeError,
                   "push() got an unexpected keyword argument '%s'",
                   Nuitka_String_Check( key ) ? Nuitka_String_AsString( key ) : "<non-string>"
               );

               goto error_exit;
            }
        }

#if PYTHON_VERSION < 300
        assert( kw_found == kw_size );
        assert( kw_only_found == 0 );
#endif
    }

    // Check if too many arguments were given in case of non star args
    if (unlikely( args_given > 2 ))
    {
#if PYTHON_VERSION < 270
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_size );
#elif PYTHON_VERSION < 330
        ERROR_TOO_MANY_ARGUMENTS( self, args_given + kw_found );
#else
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_only_found );
#endif
        goto error_exit;
    }


    // Copy normal parameter values given as part of the args list to the respective variables:

    if (likely( 0 < args_given ))
    {
         if (unlikely( _python_par_q != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 0 );
             goto error_exit;
         }

        _python_par_q = INCREASE_REFCOUNT( args[ 0 ] );
    }
    else if ( _python_par_q == NULL )
    {
        if ( 0 + self->m_defaults_given >= 2  )
        {
            _python_par_q = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 0 - 2 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 1 < args_given ))
    {
         if (unlikely( _python_par_z != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 1 );
             goto error_exit;
         }

        _python_par_z = INCREASE_REFCOUNT( args[ 1 ] );
    }
    else if ( _python_par_z == NULL )
    {
        if ( 1 + self->m_defaults_given >= 2  )
        {
            _python_par_z = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 1 - 2 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }

#if PYTHON_VERSION >= 330
    if (unlikely( _python_par_q == NULL || _python_par_z == NULL ))
    {
        PyObject *values[] = { _python_par_q, _python_par_z };
        ERROR_TOO_FEW_ARGUMENTS( self, values );

        goto error_exit;
    }
#endif


    return impl_function_4_push_of_module___main__( self, _python_par_q, _python_par_z );

error_exit:;

    Py_XDECREF( _python_par_q );
    Py_XDECREF( _python_par_z );

    return NULL;
}

static PyObject *dparse_function_4_push_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, int size )
{
    if ( size == 2 )
    {
        return impl_function_4_push_of_module___main__( self, INCREASE_REFCOUNT( args[ 0 ] ), INCREASE_REFCOUNT( args[ 1 ] ) );
    }
    else
    {
        PyObject *result = fparse_function_4_push_of_module___main__( self, args, size, NULL );
        return result;
    }

}



static PyObject *impl_function_5_uvscroll_of_module___main__( Nuitka_FunctionObject *self, PyObject *_python_par_q, PyObject *_python_par_u, PyObject *_python_par_v )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par_q( const_str_plain_q, _python_par_q );
    PyObjectLocalParameterVariableNoDel par_u( const_str_plain_u, _python_par_u );
    PyObjectLocalParameterVariableNoDel par_v( const_str_plain_v, _python_par_v );
    PyObjectLocalVariable var_p( const_str_plain_p );
    PyObjectTempVariable tmp_for_loop_1__iter_value;

    // Actual function code.
    static PyFrameObject *frame_function_5_uvscroll_of_module___main__ = NULL;

    if ( isFrameUnusable( frame_function_5_uvscroll_of_module___main__ ) )
    {
        if ( frame_function_5_uvscroll_of_module___main__ )
        {
#if _DEBUG_REFRAME
            puts( "reframe for function_5_uvscroll_of_module___main__" );
#endif
            Py_DECREF( frame_function_5_uvscroll_of_module___main__ );
        }

        frame_function_5_uvscroll_of_module___main__ = MAKE_FRAME( codeobj_751fe029f8cd873549b990a2c4fde8f0, module___main__ );
    }

    FrameGuard frame_guard( frame_function_5_uvscroll_of_module___main__ );
    try
    {
        assert( Py_REFCNT( frame_function_5_uvscroll_of_module___main__ ) == 2 ); // Frame stack
        frame_guard.setLineNumber( 87 );
        PyObjectTemporaryWithDel tmp_for_loop_1__for_iterator( MAKE_ITERATOR( PyObjectTemporary( LOOKUP_INDEX_SLICE( PyObjectTemporary( LOOKUP_ATTRIBUTE( par_q.asObject0(), const_str_plain_points ) ).asObject0(), 0, 4 ) ).asObject0() ) );
        PythonExceptionKeeper _caught_1;
#if PYTHON_VERSION < 300
        int _at_lineno_1 = 0;
#endif


        try
        {
            // Tried block:
            while( true )
            {
                frame_guard.setLineNumber( 87 );
                PyObject *_tmp_unpack_2 = ITERATOR_NEXT( tmp_for_loop_1__for_iterator.asObject0() );

                if ( _tmp_unpack_2 == NULL )
                {
                    break;
                }
                tmp_for_loop_1__iter_value.assign1( _tmp_unpack_2 );
                var_p.assign0( tmp_for_loop_1__iter_value.asObject0() );
                frame_guard.setLineNumber( 88 );
                PyObject *tmp_inplace_assign_1__inplace_target = var_p.asObject0();
                PyObject *tmp_inplace_assign_1__inplace_subscript = const_int_pos_3;
                {
                    PyObjectTempKeeper1 op1;
                    PyObjectTempKeeper0 subscr1;
                    {
                        PyObjectTemporary tmp_identifier( ( op1.assign( ( subscr1.assign( tmp_inplace_assign_1__inplace_target ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), tmp_inplace_assign_1__inplace_subscript ) ) ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), par_u.asObject0() ) ) );
                        PyObject *tmp_subscribed = tmp_inplace_assign_1__inplace_target;
                        SET_SUBSCRIPT( tmp_identifier.asObject0(), tmp_subscribed, tmp_inplace_assign_1__inplace_subscript );
                    }
                }
                frame_guard.setLineNumber( 89 );
                PyObject *tmp_inplace_assign_2__inplace_target = var_p.asObject0();
                PyObject *tmp_inplace_assign_2__inplace_subscript = const_int_pos_4;
                {
                    PyObjectTempKeeper1 op1;
                    PyObjectTempKeeper0 subscr1;
                    {
                        PyObjectTemporary tmp_identifier( ( op1.assign( ( subscr1.assign( tmp_inplace_assign_2__inplace_target ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), tmp_inplace_assign_2__inplace_subscript ) ) ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), par_v.asObject0() ) ) );
                        PyObject *tmp_subscribed = tmp_inplace_assign_2__inplace_target;
                        SET_SUBSCRIPT( tmp_identifier.asObject0(), tmp_subscribed, tmp_inplace_assign_2__inplace_subscript );
                    }
                }

                CONSIDER_THREADING();
            }
        }
        catch ( PythonException &_exception )
        {
#if PYTHON_VERSION >= 300
            if ( !_exception.hasTraceback() )
            {
                _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
            }
            else
            {
                _exception.addTraceback( frame_guard.getFrame0() );
            }
#else
            _at_lineno_1 = frame_guard.getLineNumber();
#endif

            _caught_1.save( _exception );

#if PYTHON_VERSION >= 300
            frame_guard.preserveExistingException();

            _exception.toExceptionHandler();
#endif
        }

        // Final block:
        tmp_for_loop_1__iter_value.del( true );
        tmp_for_loop_1__for_iterator.del( false );
#if PYTHON_VERSION < 300
        if ( _at_lineno_1 != 0 )
        {
           frame_guard.setLineNumber( _at_lineno_1 );
        }
#endif
        _caught_1.rethrow();
        // Final end
    }
    catch ( PythonException &_exception )
    {
        if ( !_exception.hasTraceback() )
        {
            _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
        }
        else
        {
            _exception.addTraceback( frame_guard.getFrame0() );
        }

        Py_XDECREF( frame_guard.getFrame0()->f_locals );
        frame_guard.getFrame0()->f_locals = par_v.updateLocalsDict( par_u.updateLocalsDict( par_q.updateLocalsDict( var_p.updateLocalsDict( PyDict_New() ) ) ) );

        if ( frame_guard.getFrame0() == frame_function_5_uvscroll_of_module___main__ )
        {
           Py_DECREF( frame_function_5_uvscroll_of_module___main__ );
           frame_function_5_uvscroll_of_module___main__ = NULL;
        }

        _exception.toPython();
        return NULL;
    }
    return INCREASE_REFCOUNT( Py_None );
}
static PyObject *fparse_function_5_uvscroll_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, Py_ssize_t args_size, PyObject *kw )
{
    assert( kw == NULL || PyDict_Check( kw ) );

    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_size = kw ? PyDict_Size( kw ) : 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_found = 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_only_found = 0;
    Py_ssize_t args_given = args_size;
    PyObject *_python_par_q = NULL;
    PyObject *_python_par_u = NULL;
    PyObject *_python_par_v = NULL;
    // Copy given dictionary values to the the respective variables:
    if ( kw_size > 0 )
    {
        Py_ssize_t ppos = 0;
        PyObject *key, *value;

        while( PyDict_Next( kw, &ppos, &key, &value ) )
        {
#if PYTHON_VERSION < 300
            if (unlikely( !PyString_Check( key ) && !PyUnicode_Check( key ) ))
#else
            if (unlikely( !PyUnicode_Check( key ) ))
#endif
            {
                PyErr_Format( PyExc_TypeError, "uvscroll() keywords must be strings" );
                goto error_exit;
            }

            NUITKA_MAY_BE_UNUSED bool found = false;

            Py_INCREF( key );
            Py_INCREF( value );

            // Quick path, could be our value.
            if ( found == false && const_str_plain_q == key )
            {
                assert( _python_par_q == NULL );
                _python_par_q = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_u == key )
            {
                assert( _python_par_u == NULL );
                _python_par_u = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_v == key )
            {
                assert( _python_par_v == NULL );
                _python_par_v = value;

                found = true;
                kw_found += 1;
            }

            // Slow path, compare against all parameter names.
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_q, key ) )
            {
                assert( _python_par_q == NULL );
                _python_par_q = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_u, key ) )
            {
                assert( _python_par_u == NULL );
                _python_par_u = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_v, key ) )
            {
                assert( _python_par_v == NULL );
                _python_par_v = value;

                found = true;
                kw_found += 1;
            }


            Py_DECREF( key );

            if ( found == false )
            {
               Py_DECREF( value );

               PyErr_Format(
                   PyExc_TypeError,
                   "uvscroll() got an unexpected keyword argument '%s'",
                   Nuitka_String_Check( key ) ? Nuitka_String_AsString( key ) : "<non-string>"
               );

               goto error_exit;
            }
        }

#if PYTHON_VERSION < 300
        assert( kw_found == kw_size );
        assert( kw_only_found == 0 );
#endif
    }

    // Check if too many arguments were given in case of non star args
    if (unlikely( args_given > 3 ))
    {
#if PYTHON_VERSION < 270
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_size );
#elif PYTHON_VERSION < 330
        ERROR_TOO_MANY_ARGUMENTS( self, args_given + kw_found );
#else
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_only_found );
#endif
        goto error_exit;
    }


    // Copy normal parameter values given as part of the args list to the respective variables:

    if (likely( 0 < args_given ))
    {
         if (unlikely( _python_par_q != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 0 );
             goto error_exit;
         }

        _python_par_q = INCREASE_REFCOUNT( args[ 0 ] );
    }
    else if ( _python_par_q == NULL )
    {
        if ( 0 + self->m_defaults_given >= 3  )
        {
            _python_par_q = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 0 - 3 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 1 < args_given ))
    {
         if (unlikely( _python_par_u != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 1 );
             goto error_exit;
         }

        _python_par_u = INCREASE_REFCOUNT( args[ 1 ] );
    }
    else if ( _python_par_u == NULL )
    {
        if ( 1 + self->m_defaults_given >= 3  )
        {
            _python_par_u = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 1 - 3 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 2 < args_given ))
    {
         if (unlikely( _python_par_v != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 2 );
             goto error_exit;
         }

        _python_par_v = INCREASE_REFCOUNT( args[ 2 ] );
    }
    else if ( _python_par_v == NULL )
    {
        if ( 2 + self->m_defaults_given >= 3  )
        {
            _python_par_v = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 2 - 3 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }

#if PYTHON_VERSION >= 330
    if (unlikely( _python_par_q == NULL || _python_par_u == NULL || _python_par_v == NULL ))
    {
        PyObject *values[] = { _python_par_q, _python_par_u, _python_par_v };
        ERROR_TOO_FEW_ARGUMENTS( self, values );

        goto error_exit;
    }
#endif


    return impl_function_5_uvscroll_of_module___main__( self, _python_par_q, _python_par_u, _python_par_v );

error_exit:;

    Py_XDECREF( _python_par_q );
    Py_XDECREF( _python_par_u );
    Py_XDECREF( _python_par_v );

    return NULL;
}

static PyObject *dparse_function_5_uvscroll_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, int size )
{
    if ( size == 3 )
    {
        return impl_function_5_uvscroll_of_module___main__( self, INCREASE_REFCOUNT( args[ 0 ] ), INCREASE_REFCOUNT( args[ 1 ] ), INCREASE_REFCOUNT( args[ 2 ] ) );
    }
    else
    {
        PyObject *result = fparse_function_5_uvscroll_of_module___main__( self, args, size, NULL );
        return result;
    }

}



static PyObject *impl_function_6_scale_of_module___main__( Nuitka_FunctionObject *self, PyObject *_python_par_q, PyObject *_python_par_amt )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par_q( const_str_plain_q, _python_par_q );
    PyObjectLocalParameterVariableNoDel par_amt( const_str_plain_amt, _python_par_amt );
    PyObjectLocalVariable var_p( const_str_plain_p );
    PyObjectTempVariable tmp_for_loop_1__iter_value;

    // Actual function code.
    static PyFrameObject *frame_function_6_scale_of_module___main__ = NULL;

    if ( isFrameUnusable( frame_function_6_scale_of_module___main__ ) )
    {
        if ( frame_function_6_scale_of_module___main__ )
        {
#if _DEBUG_REFRAME
            puts( "reframe for function_6_scale_of_module___main__" );
#endif
            Py_DECREF( frame_function_6_scale_of_module___main__ );
        }

        frame_function_6_scale_of_module___main__ = MAKE_FRAME( codeobj_980061b7293da93907d33296aa8a6c62, module___main__ );
    }

    FrameGuard frame_guard( frame_function_6_scale_of_module___main__ );
    try
    {
        assert( Py_REFCNT( frame_function_6_scale_of_module___main__ ) == 2 ); // Frame stack
        frame_guard.setLineNumber( 91 );
        PyObjectTemporaryWithDel tmp_for_loop_1__for_iterator( MAKE_ITERATOR( PyObjectTemporary( LOOKUP_INDEX_SLICE( PyObjectTemporary( LOOKUP_ATTRIBUTE( par_q.asObject0(), const_str_plain_points ) ).asObject0(), 0, 4 ) ).asObject0() ) );
        PythonExceptionKeeper _caught_1;
#if PYTHON_VERSION < 300
        int _at_lineno_1 = 0;
#endif


        try
        {
            // Tried block:
            while( true )
            {
                frame_guard.setLineNumber( 91 );
                PyObject *_tmp_unpack_2 = ITERATOR_NEXT( tmp_for_loop_1__for_iterator.asObject0() );

                if ( _tmp_unpack_2 == NULL )
                {
                    break;
                }
                tmp_for_loop_1__iter_value.assign1( _tmp_unpack_2 );
                var_p.assign0( tmp_for_loop_1__iter_value.asObject0() );
                frame_guard.setLineNumber( 92 );
                PyObject *tmp_inplace_assign_1__inplace_target = var_p.asObject0();
                PyObject *tmp_inplace_assign_1__inplace_subscript = const_int_0;
                {
                    PyObjectTempKeeper1 op1;
                    PyObjectTempKeeper0 subscr1;
                    {
                        PyObjectTemporary tmp_identifier( ( op1.assign( ( subscr1.assign( tmp_inplace_assign_1__inplace_target ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), tmp_inplace_assign_1__inplace_subscript ) ) ), BINARY_OPERATION( PyNumber_InPlaceMultiply, op1.asObject0(), par_amt.asObject0() ) ) );
                        PyObject *tmp_subscribed = tmp_inplace_assign_1__inplace_target;
                        SET_SUBSCRIPT( tmp_identifier.asObject0(), tmp_subscribed, tmp_inplace_assign_1__inplace_subscript );
                    }
                }
                frame_guard.setLineNumber( 93 );
                PyObject *tmp_inplace_assign_2__inplace_target = var_p.asObject0();
                PyObject *tmp_inplace_assign_2__inplace_subscript = const_int_pos_1;
                {
                    PyObjectTempKeeper1 op1;
                    PyObjectTempKeeper0 subscr1;
                    {
                        PyObjectTemporary tmp_identifier( ( op1.assign( ( subscr1.assign( tmp_inplace_assign_2__inplace_target ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), tmp_inplace_assign_2__inplace_subscript ) ) ), BINARY_OPERATION( PyNumber_InPlaceMultiply, op1.asObject0(), par_amt.asObject0() ) ) );
                        PyObject *tmp_subscribed = tmp_inplace_assign_2__inplace_target;
                        SET_SUBSCRIPT( tmp_identifier.asObject0(), tmp_subscribed, tmp_inplace_assign_2__inplace_subscript );
                    }
                }
                frame_guard.setLineNumber( 94 );
                PyObject *tmp_inplace_assign_3__inplace_target = var_p.asObject0();
                PyObject *tmp_inplace_assign_3__inplace_subscript = const_int_pos_2;
                {
                    PyObjectTempKeeper1 op1;
                    PyObjectTempKeeper0 subscr1;
                    {
                        PyObjectTemporary tmp_identifier( ( op1.assign( ( subscr1.assign( tmp_inplace_assign_3__inplace_target ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), tmp_inplace_assign_3__inplace_subscript ) ) ), BINARY_OPERATION( PyNumber_InPlaceMultiply, op1.asObject0(), par_amt.asObject0() ) ) );
                        PyObject *tmp_subscribed = tmp_inplace_assign_3__inplace_target;
                        SET_SUBSCRIPT( tmp_identifier.asObject0(), tmp_subscribed, tmp_inplace_assign_3__inplace_subscript );
                    }
                }

                CONSIDER_THREADING();
            }
        }
        catch ( PythonException &_exception )
        {
#if PYTHON_VERSION >= 300
            if ( !_exception.hasTraceback() )
            {
                _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
            }
            else
            {
                _exception.addTraceback( frame_guard.getFrame0() );
            }
#else
            _at_lineno_1 = frame_guard.getLineNumber();
#endif

            _caught_1.save( _exception );

#if PYTHON_VERSION >= 300
            frame_guard.preserveExistingException();

            _exception.toExceptionHandler();
#endif
        }

        // Final block:
        tmp_for_loop_1__iter_value.del( true );
        tmp_for_loop_1__for_iterator.del( false );
#if PYTHON_VERSION < 300
        if ( _at_lineno_1 != 0 )
        {
           frame_guard.setLineNumber( _at_lineno_1 );
        }
#endif
        _caught_1.rethrow();
        // Final end
    }
    catch ( PythonException &_exception )
    {
        if ( !_exception.hasTraceback() )
        {
            _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
        }
        else
        {
            _exception.addTraceback( frame_guard.getFrame0() );
        }

        Py_XDECREF( frame_guard.getFrame0()->f_locals );
        frame_guard.getFrame0()->f_locals = par_amt.updateLocalsDict( par_q.updateLocalsDict( var_p.updateLocalsDict( PyDict_New() ) ) );

        if ( frame_guard.getFrame0() == frame_function_6_scale_of_module___main__ )
        {
           Py_DECREF( frame_function_6_scale_of_module___main__ );
           frame_function_6_scale_of_module___main__ = NULL;
        }

        _exception.toPython();
        return NULL;
    }
    return INCREASE_REFCOUNT( Py_None );
}
static PyObject *fparse_function_6_scale_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, Py_ssize_t args_size, PyObject *kw )
{
    assert( kw == NULL || PyDict_Check( kw ) );

    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_size = kw ? PyDict_Size( kw ) : 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_found = 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_only_found = 0;
    Py_ssize_t args_given = args_size;
    PyObject *_python_par_q = NULL;
    PyObject *_python_par_amt = NULL;
    // Copy given dictionary values to the the respective variables:
    if ( kw_size > 0 )
    {
        Py_ssize_t ppos = 0;
        PyObject *key, *value;

        while( PyDict_Next( kw, &ppos, &key, &value ) )
        {
#if PYTHON_VERSION < 300
            if (unlikely( !PyString_Check( key ) && !PyUnicode_Check( key ) ))
#else
            if (unlikely( !PyUnicode_Check( key ) ))
#endif
            {
                PyErr_Format( PyExc_TypeError, "scale() keywords must be strings" );
                goto error_exit;
            }

            NUITKA_MAY_BE_UNUSED bool found = false;

            Py_INCREF( key );
            Py_INCREF( value );

            // Quick path, could be our value.
            if ( found == false && const_str_plain_q == key )
            {
                assert( _python_par_q == NULL );
                _python_par_q = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_amt == key )
            {
                assert( _python_par_amt == NULL );
                _python_par_amt = value;

                found = true;
                kw_found += 1;
            }

            // Slow path, compare against all parameter names.
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_q, key ) )
            {
                assert( _python_par_q == NULL );
                _python_par_q = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_amt, key ) )
            {
                assert( _python_par_amt == NULL );
                _python_par_amt = value;

                found = true;
                kw_found += 1;
            }


            Py_DECREF( key );

            if ( found == false )
            {
               Py_DECREF( value );

               PyErr_Format(
                   PyExc_TypeError,
                   "scale() got an unexpected keyword argument '%s'",
                   Nuitka_String_Check( key ) ? Nuitka_String_AsString( key ) : "<non-string>"
               );

               goto error_exit;
            }
        }

#if PYTHON_VERSION < 300
        assert( kw_found == kw_size );
        assert( kw_only_found == 0 );
#endif
    }

    // Check if too many arguments were given in case of non star args
    if (unlikely( args_given > 2 ))
    {
#if PYTHON_VERSION < 270
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_size );
#elif PYTHON_VERSION < 330
        ERROR_TOO_MANY_ARGUMENTS( self, args_given + kw_found );
#else
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_only_found );
#endif
        goto error_exit;
    }


    // Copy normal parameter values given as part of the args list to the respective variables:

    if (likely( 0 < args_given ))
    {
         if (unlikely( _python_par_q != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 0 );
             goto error_exit;
         }

        _python_par_q = INCREASE_REFCOUNT( args[ 0 ] );
    }
    else if ( _python_par_q == NULL )
    {
        if ( 0 + self->m_defaults_given >= 2  )
        {
            _python_par_q = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 0 - 2 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 1 < args_given ))
    {
         if (unlikely( _python_par_amt != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 1 );
             goto error_exit;
         }

        _python_par_amt = INCREASE_REFCOUNT( args[ 1 ] );
    }
    else if ( _python_par_amt == NULL )
    {
        if ( 1 + self->m_defaults_given >= 2  )
        {
            _python_par_amt = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 1 - 2 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }

#if PYTHON_VERSION >= 330
    if (unlikely( _python_par_q == NULL || _python_par_amt == NULL ))
    {
        PyObject *values[] = { _python_par_q, _python_par_amt };
        ERROR_TOO_FEW_ARGUMENTS( self, values );

        goto error_exit;
    }
#endif


    return impl_function_6_scale_of_module___main__( self, _python_par_q, _python_par_amt );

error_exit:;

    Py_XDECREF( _python_par_q );
    Py_XDECREF( _python_par_amt );

    return NULL;
}

static PyObject *dparse_function_6_scale_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, int size )
{
    if ( size == 2 )
    {
        return impl_function_6_scale_of_module___main__( self, INCREASE_REFCOUNT( args[ 0 ] ), INCREASE_REFCOUNT( args[ 1 ] ) );
    }
    else
    {
        PyObject *result = fparse_function_6_scale_of_module___main__( self, args, size, NULL );
        return result;
    }

}



static PyObject *impl_function_7_draw_point_of_module___main__( Nuitka_FunctionObject *self, PyObject *_python_par_x, PyObject *_python_par_y, PyObject *_python_par_z, PyObject *_python_par_u, PyObject *_python_par_v, PyObject *_python_par_texture )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par_x( const_str_plain_x, _python_par_x );
    PyObjectLocalParameterVariableNoDel par_y( const_str_plain_y, _python_par_y );
    PyObjectLocalParameterVariableNoDel par_z( const_str_plain_z, _python_par_z );
    PyObjectLocalParameterVariableNoDel par_u( const_str_plain_u, _python_par_u );
    PyObjectLocalParameterVariableNoDel par_v( const_str_plain_v, _python_par_v );
    PyObjectLocalParameterVariableNoDel par_texture( const_str_plain_texture, _python_par_texture );
    PyObjectLocalVariable var_texarr( const_str_plain_texarr );
    PyObjectLocalVariable var_tw( const_str_plain_tw );
    PyObjectLocalVariable var_th( const_str_plain_th );
    PyObjectTempVariable tmp_tuple_unpack_1__source_iter;
    PyObjectTempVariable tmp_tuple_unpack_1__element_1;
    PyObjectTempVariable tmp_tuple_unpack_1__element_2;
    PyObjectTempVariable tmp_tuple_unpack_1__element_3;

    // Actual function code.
    static PyFrameObject *frame_function_7_draw_point_of_module___main__ = NULL;

    if ( isFrameUnusable( frame_function_7_draw_point_of_module___main__ ) )
    {
        if ( frame_function_7_draw_point_of_module___main__ )
        {
#if _DEBUG_REFRAME
            puts( "reframe for function_7_draw_point_of_module___main__" );
#endif
            Py_DECREF( frame_function_7_draw_point_of_module___main__ );
        }

        frame_function_7_draw_point_of_module___main__ = MAKE_FRAME( codeobj_65f7660f453dcf9afd6c4c5eb198a793, module___main__ );
    }

    FrameGuard frame_guard( frame_function_7_draw_point_of_module___main__ );
    try
    {
        assert( Py_REFCNT( frame_function_7_draw_point_of_module___main__ ) == 2 ); // Frame stack
        frame_guard.setLineNumber( 97 );
        PyObjectTemporary tmp_inplace_assign_1__inplace_start( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_points ) );
        PyObjectTemporary tmp_inplace_assign_1__inplace_end( BINARY_OPERATION( PyNumber_InPlaceAdd, tmp_inplace_assign_1__inplace_start.asObject0(), const_int_pos_1 ) );
        if ( ( tmp_inplace_assign_1__inplace_start.asObject0() != tmp_inplace_assign_1__inplace_end.asObject0() ) )
        {
            {
                PyObject *tmp_identifier = tmp_inplace_assign_1__inplace_end.asObject0();
                SET_ATTRIBUTE( tmp_identifier, GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_points );
            }
        }
        frame_guard.setLineNumber( 98 );
        {
            PyObjectTempKeeper0 cmp1;
            if ( ( RICH_COMPARE_BOOL_LT( par_x.asObject0(), const_int_0 ) || ( cmp1.assign( par_x.asObject0() ), RICH_COMPARE_BOOL_GE( cmp1.asObject0(), GET_MODULE_VALUE0( const_str_plain_s_w ) ) ) ) )
            {
                return INCREASE_REFCOUNT( Py_None );
            }
        }
        frame_guard.setLineNumber( 100 );
        {
            PyObjectTempKeeper0 cmp1;
            if ( ( RICH_COMPARE_BOOL_LT( par_y.asObject0(), const_int_0 ) || ( cmp1.assign( par_y.asObject0() ), RICH_COMPARE_BOOL_GE( cmp1.asObject0(), GET_MODULE_VALUE0( const_str_plain_s_h ) ) ) ) )
            {
                return INCREASE_REFCOUNT( Py_None );
            }
        }
        frame_guard.setLineNumber( 102 );
        if ( ( RICH_COMPARE_BOOL_LE( par_z.asObject0(), const_float_0_001 ) || RICH_COMPARE_BOOL_GE( PyObjectTemporary( BINARY_OPERATION_MUL( par_z.asObject0(), const_int_pos_30 ) ).asObject0(), const_int_pos_50 ) ) )
        {
            return INCREASE_REFCOUNT( Py_None );
        }
        frame_guard.setLineNumber( 104 );
        {
            PyObjectTempKeeper1 cmp1;
            PyObjectTempKeeper0 op1;
            PyObjectTempKeeper1 op2;
            PyObjectTempKeeper1 subscr1;
            if ( ( cmp1.assign( ( subscr1.assign( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_depth ) ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), PyObjectTemporary( ( op2.assign( ( op1.assign( par_y.asObject0() ), BINARY_OPERATION_MUL( op1.asObject0(), GET_MODULE_VALUE0( const_str_plain_s_w ) ) ) ), BINARY_OPERATION_ADD( op2.asObject0(), par_x.asObject0() ) ) ).asObject0() ) ) ), RICH_COMPARE_BOOL_LT( cmp1.asObject0(), par_z.asObject0() ) ) )
            {
                frame_guard.setLineNumber( 105 );
                PyObjectTemporary tmp_inplace_assign_2__inplace_start( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_hidden ) );
                PyObjectTemporary tmp_inplace_assign_2__inplace_end( BINARY_OPERATION( PyNumber_InPlaceAdd, tmp_inplace_assign_2__inplace_start.asObject0(), const_int_pos_1 ) );
                if ( ( tmp_inplace_assign_2__inplace_start.asObject0() != tmp_inplace_assign_2__inplace_end.asObject0() ) )
                {
                    {
                        PyObject *tmp_identifier = tmp_inplace_assign_2__inplace_end.asObject0();
                        SET_ATTRIBUTE( tmp_identifier, GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_hidden );
                    }
                }
                return INCREASE_REFCOUNT( Py_None );
            }
        }
        frame_guard.setLineNumber( 107 );
        {
            PyObjectTempKeeper0 op1;
            PyObjectTempKeeper1 op2;
            {
                PyObject *tmp_identifier = par_z.asObject0();
                PyObjectTemporary tmp_subscribed( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_depth ) );
                SET_SUBSCRIPT( tmp_identifier, tmp_subscribed.asObject0(), PyObjectTemporary( ( op2.assign( ( op1.assign( par_y.asObject0() ), BINARY_OPERATION_MUL( op1.asObject0(), GET_MODULE_VALUE0( const_str_plain_s_w ) ) ) ), BINARY_OPERATION_ADD( op2.asObject0(), par_x.asObject0() ) ) ).asObject0() );
            }
        }
        frame_guard.setLineNumber( 108 );
        PythonExceptionKeeper _caught_1;
#if PYTHON_VERSION < 300
        int _at_lineno_1 = 0;
#endif


        try
        {
            // Tried block:
            tmp_tuple_unpack_1__source_iter.assign1( MAKE_ITERATOR( par_texture.asObject0() ) );
            tmp_tuple_unpack_1__element_1.assign1( UNPACK_NEXT( tmp_tuple_unpack_1__source_iter.asObject0(), 0 ) );
            tmp_tuple_unpack_1__element_2.assign1( UNPACK_NEXT( tmp_tuple_unpack_1__source_iter.asObject0(), 1 ) );
            tmp_tuple_unpack_1__element_3.assign1( UNPACK_NEXT( tmp_tuple_unpack_1__source_iter.asObject0(), 2 ) );
            UNPACK_ITERATOR_CHECK( tmp_tuple_unpack_1__source_iter.asObject0(), 3 );
            var_texarr.assign0( tmp_tuple_unpack_1__element_1.asObject0() );
            var_tw.assign0( tmp_tuple_unpack_1__element_2.asObject0() );
            var_th.assign0( tmp_tuple_unpack_1__element_3.asObject0() );
        }
        catch ( PythonException &_exception )
        {
#if PYTHON_VERSION >= 300
            if ( !_exception.hasTraceback() )
            {
                _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
            }
            else
            {
                _exception.addTraceback( frame_guard.getFrame0() );
            }
#else
            _at_lineno_1 = frame_guard.getLineNumber();
#endif

            _caught_1.save( _exception );

#if PYTHON_VERSION >= 300
            frame_guard.preserveExistingException();

            _exception.toExceptionHandler();
#endif
        }

        // Final block:
        tmp_tuple_unpack_1__source_iter.del( true );
        tmp_tuple_unpack_1__element_1.del( true );
        tmp_tuple_unpack_1__element_2.del( true );
        tmp_tuple_unpack_1__element_3.del( true );
#if PYTHON_VERSION < 300
        if ( _at_lineno_1 != 0 )
        {
           frame_guard.setLineNumber( _at_lineno_1 );
        }
#endif
        _caught_1.rethrow();
        // Final end
        frame_guard.setLineNumber( 109 );
        {
            PyObjectTempKeeper0 make_tuple1;
            PyObjectTempKeeper1 make_tuple2;
            PyObjectTempKeeper1 op1;
            PyObjectTempKeeper1 op2;
            PyObjectTempKeeper0 subscr1;
            PyObjectTempKeeper1 subscr2;
            {
                PyObjectTemporary tmp_identifier( ( subscr2.assign( ( subscr1.assign( var_texarr.asObject0() ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), PyObjectTemporary( TO_INT( PyObjectTemporary( BINARY_OPERATION_MUL( par_z.asObject0(), const_int_pos_4 ) ).asObject0() ) ).asObject0() ) ) ), LOOKUP_SUBSCRIPT( subscr2.asObject0(), PyObjectTemporary( ( make_tuple2.assign( TO_INT( PyObjectTemporary( ( op1.assign( BINARY_OPERATION_REMAINDER( par_u.asObject0(), const_int_pos_1 ) ), BINARY_OPERATION_MUL( op1.asObject0(), var_tw.asObject0() ) ) ).asObject0() ) ), MAKE_TUPLE2( make_tuple2.asObject0(), PyObjectTemporary( TO_INT( PyObjectTemporary( ( op2.assign( BINARY_OPERATION_REMAINDER( par_v.asObject0(), const_int_pos_1 ) ), BINARY_OPERATION_MUL( op2.asObject0(), var_th.asObject0() ) ) ).asObject0() ) ).asObject0() ) ) ).asObject0() ) ) );
                PyObjectTemporary tmp_subscribed( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_arr ) );
                SET_SUBSCRIPT( tmp_identifier.asObject0(), tmp_subscribed.asObject0(), PyObjectTemporary( ( make_tuple1.assign( par_x.asObject0() ), MAKE_TUPLE2( make_tuple1.asObject0(), par_y.asObject0() ) ) ).asObject0() );
            }
        }
    }
    catch ( PythonException &_exception )
    {
        if ( !_exception.hasTraceback() )
        {
            _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
        }
        else
        {
            _exception.addTraceback( frame_guard.getFrame0() );
        }

        Py_XDECREF( frame_guard.getFrame0()->f_locals );
        frame_guard.getFrame0()->f_locals = par_texture.updateLocalsDict( par_v.updateLocalsDict( par_u.updateLocalsDict( par_z.updateLocalsDict( par_y.updateLocalsDict( par_x.updateLocalsDict( var_th.updateLocalsDict( var_tw.updateLocalsDict( var_texarr.updateLocalsDict( PyDict_New() ) ) ) ) ) ) ) ) );

        if ( frame_guard.getFrame0() == frame_function_7_draw_point_of_module___main__ )
        {
           Py_DECREF( frame_function_7_draw_point_of_module___main__ );
           frame_function_7_draw_point_of_module___main__ = NULL;
        }

        _exception.toPython();
        return NULL;
    }
    return INCREASE_REFCOUNT( Py_None );
}
static PyObject *fparse_function_7_draw_point_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, Py_ssize_t args_size, PyObject *kw )
{
    assert( kw == NULL || PyDict_Check( kw ) );

    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_size = kw ? PyDict_Size( kw ) : 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_found = 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_only_found = 0;
    Py_ssize_t args_given = args_size;
    PyObject *_python_par_x = NULL;
    PyObject *_python_par_y = NULL;
    PyObject *_python_par_z = NULL;
    PyObject *_python_par_u = NULL;
    PyObject *_python_par_v = NULL;
    PyObject *_python_par_texture = NULL;
    // Copy given dictionary values to the the respective variables:
    if ( kw_size > 0 )
    {
        Py_ssize_t ppos = 0;
        PyObject *key, *value;

        while( PyDict_Next( kw, &ppos, &key, &value ) )
        {
#if PYTHON_VERSION < 300
            if (unlikely( !PyString_Check( key ) && !PyUnicode_Check( key ) ))
#else
            if (unlikely( !PyUnicode_Check( key ) ))
#endif
            {
                PyErr_Format( PyExc_TypeError, "draw_point() keywords must be strings" );
                goto error_exit;
            }

            NUITKA_MAY_BE_UNUSED bool found = false;

            Py_INCREF( key );
            Py_INCREF( value );

            // Quick path, could be our value.
            if ( found == false && const_str_plain_x == key )
            {
                assert( _python_par_x == NULL );
                _python_par_x = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_y == key )
            {
                assert( _python_par_y == NULL );
                _python_par_y = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_z == key )
            {
                assert( _python_par_z == NULL );
                _python_par_z = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_u == key )
            {
                assert( _python_par_u == NULL );
                _python_par_u = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_v == key )
            {
                assert( _python_par_v == NULL );
                _python_par_v = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_texture == key )
            {
                assert( _python_par_texture == NULL );
                _python_par_texture = value;

                found = true;
                kw_found += 1;
            }

            // Slow path, compare against all parameter names.
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_x, key ) )
            {
                assert( _python_par_x == NULL );
                _python_par_x = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_y, key ) )
            {
                assert( _python_par_y == NULL );
                _python_par_y = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_z, key ) )
            {
                assert( _python_par_z == NULL );
                _python_par_z = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_u, key ) )
            {
                assert( _python_par_u == NULL );
                _python_par_u = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_v, key ) )
            {
                assert( _python_par_v == NULL );
                _python_par_v = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_texture, key ) )
            {
                assert( _python_par_texture == NULL );
                _python_par_texture = value;

                found = true;
                kw_found += 1;
            }


            Py_DECREF( key );

            if ( found == false )
            {
               Py_DECREF( value );

               PyErr_Format(
                   PyExc_TypeError,
                   "draw_point() got an unexpected keyword argument '%s'",
                   Nuitka_String_Check( key ) ? Nuitka_String_AsString( key ) : "<non-string>"
               );

               goto error_exit;
            }
        }

#if PYTHON_VERSION < 300
        assert( kw_found == kw_size );
        assert( kw_only_found == 0 );
#endif
    }

    // Check if too many arguments were given in case of non star args
    if (unlikely( args_given > 6 ))
    {
#if PYTHON_VERSION < 270
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_size );
#elif PYTHON_VERSION < 330
        ERROR_TOO_MANY_ARGUMENTS( self, args_given + kw_found );
#else
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_only_found );
#endif
        goto error_exit;
    }


    // Copy normal parameter values given as part of the args list to the respective variables:

    if (likely( 0 < args_given ))
    {
         if (unlikely( _python_par_x != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 0 );
             goto error_exit;
         }

        _python_par_x = INCREASE_REFCOUNT( args[ 0 ] );
    }
    else if ( _python_par_x == NULL )
    {
        if ( 0 + self->m_defaults_given >= 6  )
        {
            _python_par_x = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 0 - 6 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 1 < args_given ))
    {
         if (unlikely( _python_par_y != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 1 );
             goto error_exit;
         }

        _python_par_y = INCREASE_REFCOUNT( args[ 1 ] );
    }
    else if ( _python_par_y == NULL )
    {
        if ( 1 + self->m_defaults_given >= 6  )
        {
            _python_par_y = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 1 - 6 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 2 < args_given ))
    {
         if (unlikely( _python_par_z != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 2 );
             goto error_exit;
         }

        _python_par_z = INCREASE_REFCOUNT( args[ 2 ] );
    }
    else if ( _python_par_z == NULL )
    {
        if ( 2 + self->m_defaults_given >= 6  )
        {
            _python_par_z = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 2 - 6 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 3 < args_given ))
    {
         if (unlikely( _python_par_u != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 3 );
             goto error_exit;
         }

        _python_par_u = INCREASE_REFCOUNT( args[ 3 ] );
    }
    else if ( _python_par_u == NULL )
    {
        if ( 3 + self->m_defaults_given >= 6  )
        {
            _python_par_u = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 3 - 6 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 4 < args_given ))
    {
         if (unlikely( _python_par_v != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 4 );
             goto error_exit;
         }

        _python_par_v = INCREASE_REFCOUNT( args[ 4 ] );
    }
    else if ( _python_par_v == NULL )
    {
        if ( 4 + self->m_defaults_given >= 6  )
        {
            _python_par_v = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 4 - 6 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 5 < args_given ))
    {
         if (unlikely( _python_par_texture != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 5 );
             goto error_exit;
         }

        _python_par_texture = INCREASE_REFCOUNT( args[ 5 ] );
    }
    else if ( _python_par_texture == NULL )
    {
        if ( 5 + self->m_defaults_given >= 6  )
        {
            _python_par_texture = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 5 - 6 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }

#if PYTHON_VERSION >= 330
    if (unlikely( _python_par_x == NULL || _python_par_y == NULL || _python_par_z == NULL || _python_par_u == NULL || _python_par_v == NULL || _python_par_texture == NULL ))
    {
        PyObject *values[] = { _python_par_x, _python_par_y, _python_par_z, _python_par_u, _python_par_v, _python_par_texture };
        ERROR_TOO_FEW_ARGUMENTS( self, values );

        goto error_exit;
    }
#endif


    return impl_function_7_draw_point_of_module___main__( self, _python_par_x, _python_par_y, _python_par_z, _python_par_u, _python_par_v, _python_par_texture );

error_exit:;

    Py_XDECREF( _python_par_x );
    Py_XDECREF( _python_par_y );
    Py_XDECREF( _python_par_z );
    Py_XDECREF( _python_par_u );
    Py_XDECREF( _python_par_v );
    Py_XDECREF( _python_par_texture );

    return NULL;
}

static PyObject *dparse_function_7_draw_point_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, int size )
{
    if ( size == 6 )
    {
        return impl_function_7_draw_point_of_module___main__( self, INCREASE_REFCOUNT( args[ 0 ] ), INCREASE_REFCOUNT( args[ 1 ] ), INCREASE_REFCOUNT( args[ 2 ] ), INCREASE_REFCOUNT( args[ 3 ] ), INCREASE_REFCOUNT( args[ 4 ] ), INCREASE_REFCOUNT( args[ 5 ] ) );
    }
    else
    {
        PyObject *result = fparse_function_7_draw_point_of_module___main__( self, args, size, NULL );
        return result;
    }

}



static PyObject *impl_function_8_draw_tri_of_module___main__( Nuitka_FunctionObject *self, PyObject *_python_par_a, PyObject *_python_par_b, PyObject *_python_par_c, PyObject *_python_par_texture )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par_a( const_str_plain_a, _python_par_a );
    PyObjectLocalParameterVariableNoDel par_b( const_str_plain_b, _python_par_b );
    PyObjectLocalParameterVariableNoDel par_c( const_str_plain_c, _python_par_c );
    PyObjectLocalParameterVariableNoDel par_texture( const_str_plain_texture, _python_par_texture );
    PyObjectTempVariable tmp_tuple_unpack_1__source_iter;
    PyObjectTempVariable tmp_tuple_unpack_1__element_1;
    PyObjectTempVariable tmp_tuple_unpack_1__element_2;
    PyObjectTempVariable tmp_tuple_unpack_1__element_3;

    // Actual function code.
    static PyFrameObject *frame_function_8_draw_tri_of_module___main__ = NULL;

    if ( isFrameUnusable( frame_function_8_draw_tri_of_module___main__ ) )
    {
        if ( frame_function_8_draw_tri_of_module___main__ )
        {
#if _DEBUG_REFRAME
            puts( "reframe for function_8_draw_tri_of_module___main__" );
#endif
            Py_DECREF( frame_function_8_draw_tri_of_module___main__ );
        }

        frame_function_8_draw_tri_of_module___main__ = MAKE_FRAME( codeobj_23d26e9a4357f26a48ab4b92efd93125, module___main__ );
    }

    FrameGuard frame_guard( frame_function_8_draw_tri_of_module___main__ );
    try
    {
        assert( Py_REFCNT( frame_function_8_draw_tri_of_module___main__ ) == 2 ); // Frame stack
        frame_guard.setLineNumber( 114 );
        PythonExceptionKeeper _caught_1;
#if PYTHON_VERSION < 300
        int _at_lineno_1 = 0;
#endif


        try
        {
            // Tried block:
            {
                PyObjectTempKeeper0 make_list1;
                PyObjectTempKeeper0 make_list2;
                tmp_tuple_unpack_1__source_iter.assign1( MAKE_ITERATOR( PyObjectTemporary( CALL_FUNCTION( LOOKUP_BUILTIN( const_str_plain_sorted ), PyObjectTemporary( MAKE_TUPLE1( PyObjectTemporary( ( make_list1.assign( par_a.asObject0() ), make_list2.assign( par_b.asObject0() ), MAKE_LIST3( make_list1.asObject1(), make_list2.asObject1(), par_c.asObject1() ) ) ).asObject0() ) ).asObject0(), PyObjectTemporary( MAKE_DICT1( PyObjectTemporary( MAKE_FUNCTION_lambda_1_lambda_of_function_8_draw_tri_of_module___main__(  ) ).asObject0(), const_str_plain_key ) ).asObject0() ) ).asObject0() ) );
            }
            tmp_tuple_unpack_1__element_1.assign1( UNPACK_NEXT( tmp_tuple_unpack_1__source_iter.asObject0(), 0 ) );
            tmp_tuple_unpack_1__element_2.assign1( UNPACK_NEXT( tmp_tuple_unpack_1__source_iter.asObject0(), 1 ) );
            tmp_tuple_unpack_1__element_3.assign1( UNPACK_NEXT( tmp_tuple_unpack_1__source_iter.asObject0(), 2 ) );
            UNPACK_ITERATOR_CHECK( tmp_tuple_unpack_1__source_iter.asObject0(), 3 );
            par_a.assign0( tmp_tuple_unpack_1__element_1.asObject0() );
            par_b.assign0( tmp_tuple_unpack_1__element_2.asObject0() );
            par_c.assign0( tmp_tuple_unpack_1__element_3.asObject0() );
        }
        catch ( PythonException &_exception )
        {
#if PYTHON_VERSION >= 300
            if ( !_exception.hasTraceback() )
            {
                _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
            }
            else
            {
                _exception.addTraceback( frame_guard.getFrame0() );
            }
#else
            _at_lineno_1 = frame_guard.getLineNumber();
#endif

            _caught_1.save( _exception );

#if PYTHON_VERSION >= 300
            frame_guard.preserveExistingException();

            _exception.toExceptionHandler();
#endif
        }

        // Final block:
        tmp_tuple_unpack_1__source_iter.del( true );
        tmp_tuple_unpack_1__element_1.del( true );
        tmp_tuple_unpack_1__element_2.del( true );
        tmp_tuple_unpack_1__element_3.del( true );
#if PYTHON_VERSION < 300
        if ( _at_lineno_1 != 0 )
        {
           frame_guard.setLineNumber( _at_lineno_1 );
        }
#endif
        _caught_1.rethrow();
        // Final end
        frame_guard.setLineNumber( 116 );
        {
            PyObjectTempKeeper1 cmp1;
            if ( ( cmp1.assign( LOOKUP_SUBSCRIPT_CONST( par_a.asObject0(), const_int_pos_1, 1 ) ), RICH_COMPARE_BOOL_EQ( cmp1.asObject0(), PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_b.asObject0(), const_int_pos_1, 1 ) ).asObject0() ) ) )
            {
                frame_guard.setLineNumber( 117 );
                {
                    PyObjectTempKeeper0 call1;
                    PyObjectTempKeeper0 call2;
                    PyObjectTempKeeper0 call3;
                    PyObjectTempKeeper0 call4;
                    DECREASE_REFCOUNT( ( call1.assign( GET_MODULE_VALUE0( const_str_plain_draw_tri_point_down ) ), call2.assign( par_a.asObject0() ), call3.assign( par_b.asObject0() ), call4.assign( par_c.asObject0() ), CALL_FUNCTION_WITH_ARGS4( call1.asObject0(), call2.asObject0(), call3.asObject0(), call4.asObject0(), par_texture.asObject0() ) ) );
                }
                return INCREASE_REFCOUNT( Py_None );
            }
        }
        frame_guard.setLineNumber( 120 );
        {
            PyObjectTempKeeper1 cmp1;
            if ( ( cmp1.assign( LOOKUP_SUBSCRIPT_CONST( par_b.asObject0(), const_int_pos_1, 1 ) ), RICH_COMPARE_BOOL_EQ( cmp1.asObject0(), PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_1, 1 ) ).asObject0() ) ) )
            {
                frame_guard.setLineNumber( 121 );
                {
                    PyObjectTempKeeper0 call1;
                    PyObjectTempKeeper0 call2;
                    PyObjectTempKeeper0 call3;
                    PyObjectTempKeeper0 call4;
                    DECREASE_REFCOUNT( ( call1.assign( GET_MODULE_VALUE0( const_str_plain_draw_tri_point_up ) ), call2.assign( par_a.asObject0() ), call3.assign( par_b.asObject0() ), call4.assign( par_c.asObject0() ), CALL_FUNCTION_WITH_ARGS4( call1.asObject0(), call2.asObject0(), call3.asObject0(), call4.asObject0(), par_texture.asObject0() ) ) );
                }
                return INCREASE_REFCOUNT( Py_None );
            }
            else
            {
                frame_guard.setLineNumber( 125 );
                {
                    PyObjectTempKeeper0 call1;
                    PyObjectTempKeeper0 call2;
                    PyObjectTempKeeper0 call3;
                    PyObjectTempKeeper0 call4;
                    DECREASE_REFCOUNT( ( call1.assign( GET_MODULE_VALUE0( const_str_plain_draw_tri_split ) ), call2.assign( par_a.asObject0() ), call3.assign( par_b.asObject0() ), call4.assign( par_c.asObject0() ), CALL_FUNCTION_WITH_ARGS4( call1.asObject0(), call2.asObject0(), call3.asObject0(), call4.asObject0(), par_texture.asObject0() ) ) );
                }
            }
        }
    }
    catch ( PythonException &_exception )
    {
        if ( !_exception.hasTraceback() )
        {
            _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
        }
        else
        {
            _exception.addTraceback( frame_guard.getFrame0() );
        }

        Py_XDECREF( frame_guard.getFrame0()->f_locals );
        frame_guard.getFrame0()->f_locals = par_texture.updateLocalsDict( par_c.updateLocalsDict( par_b.updateLocalsDict( par_a.updateLocalsDict( PyDict_New() ) ) ) );

        if ( frame_guard.getFrame0() == frame_function_8_draw_tri_of_module___main__ )
        {
           Py_DECREF( frame_function_8_draw_tri_of_module___main__ );
           frame_function_8_draw_tri_of_module___main__ = NULL;
        }

        _exception.toPython();
        return NULL;
    }
    return INCREASE_REFCOUNT( Py_None );
}
static PyObject *fparse_function_8_draw_tri_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, Py_ssize_t args_size, PyObject *kw )
{
    assert( kw == NULL || PyDict_Check( kw ) );

    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_size = kw ? PyDict_Size( kw ) : 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_found = 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_only_found = 0;
    Py_ssize_t args_given = args_size;
    PyObject *_python_par_a = NULL;
    PyObject *_python_par_b = NULL;
    PyObject *_python_par_c = NULL;
    PyObject *_python_par_texture = NULL;
    // Copy given dictionary values to the the respective variables:
    if ( kw_size > 0 )
    {
        Py_ssize_t ppos = 0;
        PyObject *key, *value;

        while( PyDict_Next( kw, &ppos, &key, &value ) )
        {
#if PYTHON_VERSION < 300
            if (unlikely( !PyString_Check( key ) && !PyUnicode_Check( key ) ))
#else
            if (unlikely( !PyUnicode_Check( key ) ))
#endif
            {
                PyErr_Format( PyExc_TypeError, "draw_tri() keywords must be strings" );
                goto error_exit;
            }

            NUITKA_MAY_BE_UNUSED bool found = false;

            Py_INCREF( key );
            Py_INCREF( value );

            // Quick path, could be our value.
            if ( found == false && const_str_plain_a == key )
            {
                assert( _python_par_a == NULL );
                _python_par_a = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_b == key )
            {
                assert( _python_par_b == NULL );
                _python_par_b = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_c == key )
            {
                assert( _python_par_c == NULL );
                _python_par_c = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_texture == key )
            {
                assert( _python_par_texture == NULL );
                _python_par_texture = value;

                found = true;
                kw_found += 1;
            }

            // Slow path, compare against all parameter names.
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_a, key ) )
            {
                assert( _python_par_a == NULL );
                _python_par_a = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_b, key ) )
            {
                assert( _python_par_b == NULL );
                _python_par_b = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_c, key ) )
            {
                assert( _python_par_c == NULL );
                _python_par_c = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_texture, key ) )
            {
                assert( _python_par_texture == NULL );
                _python_par_texture = value;

                found = true;
                kw_found += 1;
            }


            Py_DECREF( key );

            if ( found == false )
            {
               Py_DECREF( value );

               PyErr_Format(
                   PyExc_TypeError,
                   "draw_tri() got an unexpected keyword argument '%s'",
                   Nuitka_String_Check( key ) ? Nuitka_String_AsString( key ) : "<non-string>"
               );

               goto error_exit;
            }
        }

#if PYTHON_VERSION < 300
        assert( kw_found == kw_size );
        assert( kw_only_found == 0 );
#endif
    }

    // Check if too many arguments were given in case of non star args
    if (unlikely( args_given > 4 ))
    {
#if PYTHON_VERSION < 270
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_size );
#elif PYTHON_VERSION < 330
        ERROR_TOO_MANY_ARGUMENTS( self, args_given + kw_found );
#else
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_only_found );
#endif
        goto error_exit;
    }


    // Copy normal parameter values given as part of the args list to the respective variables:

    if (likely( 0 < args_given ))
    {
         if (unlikely( _python_par_a != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 0 );
             goto error_exit;
         }

        _python_par_a = INCREASE_REFCOUNT( args[ 0 ] );
    }
    else if ( _python_par_a == NULL )
    {
        if ( 0 + self->m_defaults_given >= 4  )
        {
            _python_par_a = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 0 - 4 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 1 < args_given ))
    {
         if (unlikely( _python_par_b != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 1 );
             goto error_exit;
         }

        _python_par_b = INCREASE_REFCOUNT( args[ 1 ] );
    }
    else if ( _python_par_b == NULL )
    {
        if ( 1 + self->m_defaults_given >= 4  )
        {
            _python_par_b = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 1 - 4 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 2 < args_given ))
    {
         if (unlikely( _python_par_c != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 2 );
             goto error_exit;
         }

        _python_par_c = INCREASE_REFCOUNT( args[ 2 ] );
    }
    else if ( _python_par_c == NULL )
    {
        if ( 2 + self->m_defaults_given >= 4  )
        {
            _python_par_c = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 2 - 4 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 3 < args_given ))
    {
         if (unlikely( _python_par_texture != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 3 );
             goto error_exit;
         }

        _python_par_texture = INCREASE_REFCOUNT( args[ 3 ] );
    }
    else if ( _python_par_texture == NULL )
    {
        if ( 3 + self->m_defaults_given >= 4  )
        {
            _python_par_texture = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 3 - 4 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }

#if PYTHON_VERSION >= 330
    if (unlikely( _python_par_a == NULL || _python_par_b == NULL || _python_par_c == NULL || _python_par_texture == NULL ))
    {
        PyObject *values[] = { _python_par_a, _python_par_b, _python_par_c, _python_par_texture };
        ERROR_TOO_FEW_ARGUMENTS( self, values );

        goto error_exit;
    }
#endif


    return impl_function_8_draw_tri_of_module___main__( self, _python_par_a, _python_par_b, _python_par_c, _python_par_texture );

error_exit:;

    Py_XDECREF( _python_par_a );
    Py_XDECREF( _python_par_b );
    Py_XDECREF( _python_par_c );
    Py_XDECREF( _python_par_texture );

    return NULL;
}

static PyObject *dparse_function_8_draw_tri_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, int size )
{
    if ( size == 4 )
    {
        return impl_function_8_draw_tri_of_module___main__( self, INCREASE_REFCOUNT( args[ 0 ] ), INCREASE_REFCOUNT( args[ 1 ] ), INCREASE_REFCOUNT( args[ 2 ] ), INCREASE_REFCOUNT( args[ 3 ] ) );
    }
    else
    {
        PyObject *result = fparse_function_8_draw_tri_of_module___main__( self, args, size, NULL );
        return result;
    }

}



static PyObject *impl_lambda_1_lambda_of_function_8_draw_tri_of_module___main__( Nuitka_FunctionObject *self, PyObject *_python_par_t )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par_t( const_str_plain_t, _python_par_t );

    // Actual function code.
    static PyFrameObject *frame_lambda_1_lambda_of_function_8_draw_tri_of_module___main__ = NULL;

    if ( isFrameUnusable( frame_lambda_1_lambda_of_function_8_draw_tri_of_module___main__ ) )
    {
        if ( frame_lambda_1_lambda_of_function_8_draw_tri_of_module___main__ )
        {
#if _DEBUG_REFRAME
            puts( "reframe for lambda_1_lambda_of_function_8_draw_tri_of_module___main__" );
#endif
            Py_DECREF( frame_lambda_1_lambda_of_function_8_draw_tri_of_module___main__ );
        }

        frame_lambda_1_lambda_of_function_8_draw_tri_of_module___main__ = MAKE_FRAME( codeobj_607cf003ee6a434a10ad254c191c3224, module___main__ );
    }

    FrameGuard frame_guard( frame_lambda_1_lambda_of_function_8_draw_tri_of_module___main__ );
    try
    {
        assert( Py_REFCNT( frame_lambda_1_lambda_of_function_8_draw_tri_of_module___main__ ) == 2 ); // Frame stack
        frame_guard.setLineNumber( 114 );
        return LOOKUP_SUBSCRIPT_CONST( par_t.asObject0(), const_int_pos_1, 1 );
    }
    catch ( PythonException &_exception )
    {
        if ( !_exception.hasTraceback() )
        {
            _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
        }
        else
        {
            _exception.addTraceback( frame_guard.getFrame0() );
        }

        Py_XDECREF( frame_guard.getFrame0()->f_locals );
        frame_guard.getFrame0()->f_locals = par_t.updateLocalsDict( PyDict_New() );

        if ( frame_guard.getFrame0() == frame_lambda_1_lambda_of_function_8_draw_tri_of_module___main__ )
        {
           Py_DECREF( frame_lambda_1_lambda_of_function_8_draw_tri_of_module___main__ );
           frame_lambda_1_lambda_of_function_8_draw_tri_of_module___main__ = NULL;
        }

        _exception.toPython();
        return NULL;
    }

}
static PyObject *fparse_lambda_1_lambda_of_function_8_draw_tri_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, Py_ssize_t args_size, PyObject *kw )
{
    assert( kw == NULL || PyDict_Check( kw ) );

    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_size = kw ? PyDict_Size( kw ) : 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_found = 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_only_found = 0;
    Py_ssize_t args_given = args_size;
    PyObject *_python_par_t = NULL;
    // Copy given dictionary values to the the respective variables:
    if ( kw_size > 0 )
    {
        Py_ssize_t ppos = 0;
        PyObject *key, *value;

        while( PyDict_Next( kw, &ppos, &key, &value ) )
        {
#if PYTHON_VERSION < 300
            if (unlikely( !PyString_Check( key ) && !PyUnicode_Check( key ) ))
#else
            if (unlikely( !PyUnicode_Check( key ) ))
#endif
            {
                PyErr_Format( PyExc_TypeError, "<lambda>() keywords must be strings" );
                goto error_exit;
            }

            NUITKA_MAY_BE_UNUSED bool found = false;

            Py_INCREF( key );
            Py_INCREF( value );

            // Quick path, could be our value.
            if ( found == false && const_str_plain_t == key )
            {
                assert( _python_par_t == NULL );
                _python_par_t = value;

                found = true;
                kw_found += 1;
            }

            // Slow path, compare against all parameter names.
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_t, key ) )
            {
                assert( _python_par_t == NULL );
                _python_par_t = value;

                found = true;
                kw_found += 1;
            }


            Py_DECREF( key );

            if ( found == false )
            {
               Py_DECREF( value );

               PyErr_Format(
                   PyExc_TypeError,
                   "<lambda>() got an unexpected keyword argument '%s'",
                   Nuitka_String_Check( key ) ? Nuitka_String_AsString( key ) : "<non-string>"
               );

               goto error_exit;
            }
        }

#if PYTHON_VERSION < 300
        assert( kw_found == kw_size );
        assert( kw_only_found == 0 );
#endif
    }

    // Check if too many arguments were given in case of non star args
    if (unlikely( args_given > 1 ))
    {
#if PYTHON_VERSION < 270
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_size );
#elif PYTHON_VERSION < 330
        ERROR_TOO_MANY_ARGUMENTS( self, args_given + kw_found );
#else
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_only_found );
#endif
        goto error_exit;
    }


    // Copy normal parameter values given as part of the args list to the respective variables:

    if (likely( 0 < args_given ))
    {
         if (unlikely( _python_par_t != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 0 );
             goto error_exit;
         }

        _python_par_t = INCREASE_REFCOUNT( args[ 0 ] );
    }
    else if ( _python_par_t == NULL )
    {
        if ( 0 + self->m_defaults_given >= 1  )
        {
            _python_par_t = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 0 - 1 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }

#if PYTHON_VERSION >= 330
    if (unlikely( _python_par_t == NULL ))
    {
        PyObject *values[] = { _python_par_t };
        ERROR_TOO_FEW_ARGUMENTS( self, values );

        goto error_exit;
    }
#endif


    return impl_lambda_1_lambda_of_function_8_draw_tri_of_module___main__( self, _python_par_t );

error_exit:;

    Py_XDECREF( _python_par_t );

    return NULL;
}

static PyObject *dparse_lambda_1_lambda_of_function_8_draw_tri_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, int size )
{
    if ( size == 1 )
    {
        return impl_lambda_1_lambda_of_function_8_draw_tri_of_module___main__( self, INCREASE_REFCOUNT( args[ 0 ] ) );
    }
    else
    {
        PyObject *result = fparse_lambda_1_lambda_of_function_8_draw_tri_of_module___main__( self, args, size, NULL );
        return result;
    }

}



static PyObject *impl_function_9_draw_tri_split_of_module___main__( Nuitka_FunctionObject *self, PyObject *_python_par_a, PyObject *_python_par_b, PyObject *_python_par_c, PyObject *_python_par_texture )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par_a( const_str_plain_a, _python_par_a );
    PyObjectLocalParameterVariableNoDel par_b( const_str_plain_b, _python_par_b );
    PyObjectLocalParameterVariableNoDel par_c( const_str_plain_c, _python_par_c );
    PyObjectLocalParameterVariableNoDel par_texture( const_str_plain_texture, _python_par_texture );
    PyObjectLocalVariable var_d( const_str_plain_d );
    PyObjectLocalVariable var_m( const_str_plain_m );
    PyObjectLocalVariable var_i( const_str_plain_i );

    // Actual function code.
    static PyFrameObject *frame_function_9_draw_tri_split_of_module___main__ = NULL;

    if ( isFrameUnusable( frame_function_9_draw_tri_split_of_module___main__ ) )
    {
        if ( frame_function_9_draw_tri_split_of_module___main__ )
        {
#if _DEBUG_REFRAME
            puts( "reframe for function_9_draw_tri_split_of_module___main__" );
#endif
            Py_DECREF( frame_function_9_draw_tri_split_of_module___main__ );
        }

        frame_function_9_draw_tri_split_of_module___main__ = MAKE_FRAME( codeobj_eb25d1d79ff30a6bfe8e236e1d3f2076, module___main__ );
    }

    FrameGuard frame_guard( frame_function_9_draw_tri_split_of_module___main__ );
    try
    {
        assert( Py_REFCNT( frame_function_9_draw_tri_split_of_module___main__ ) == 2 ); // Frame stack
        frame_guard.setLineNumber( 129 );
        var_d.assign1( MAKE_LIST5( INCREASE_REFCOUNT( const_int_0 ), LOOKUP_SUBSCRIPT_CONST( par_b.asObject0(), const_int_pos_1, 1 ), INCREASE_REFCOUNT( const_int_0 ), INCREASE_REFCOUNT( const_int_0 ), INCREASE_REFCOUNT( const_int_0 ) ) );
        frame_guard.setLineNumber( 130 );
        {
            PyObjectTempKeeper1 cmp1;
            if ( ( cmp1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_0, 0 ) ), RICH_COMPARE_BOOL_EQ( cmp1.asObject0(), PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_a.asObject0(), const_int_0, 0 ) ).asObject0() ) ) )
            {
                frame_guard.setLineNumber( 131 );
                {
                    PyObjectTemporary tmp_identifier( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_0, 0 ) );
                    SET_SUBSCRIPT_CONST( tmp_identifier.asObject0(), var_d.asObject0(), const_int_0, 0 );
                }
            }
            else
            {
                frame_guard.setLineNumber( 133 );
                {
                    PyObjectTempKeeper1 op1;
                    PyObjectTempKeeper1 op2;
                    PyObjectTempKeeper1 op3;
                    var_m.assign1( ( op3.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_1, 1 ) ), BINARY_OPERATION_SUB( op1.asObject0(), PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_a.asObject0(), const_int_pos_1, 1 ) ).asObject0() ) ) ), BINARY_OPERATION_DIV( op3.asObject0(), PyObjectTemporary( ( op2.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_0, 0 ) ), BINARY_OPERATION_SUB( op2.asObject0(), PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_a.asObject0(), const_int_0, 0 ) ).asObject0() ) ) ).asObject0() ) ) );
                }
                frame_guard.setLineNumber( 134 );
                {
                    PyObjectTempKeeper0 op1;
                    PyObjectTempKeeper1 op2;
                    var_i.assign1( ( op2.assign( LOOKUP_SUBSCRIPT_CONST( par_a.asObject0(), const_int_pos_1, 1 ) ), BINARY_OPERATION_SUB( op2.asObject0(), PyObjectTemporary( ( op1.assign( var_m.asObject0() ), BINARY_OPERATION_MUL( op1.asObject0(), PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_a.asObject0(), const_int_0, 0 ) ).asObject0() ) ) ).asObject0() ) ) );
                }
                frame_guard.setLineNumber( 135 );
                {
                    PyObjectTempKeeper1 op1;
                    PyObjectTempKeeper1 op2;
                    {
                        PyObjectTemporary tmp_identifier( ( op2.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( var_d.asObject0(), const_int_pos_1, 1 ) ), BINARY_OPERATION_SUB( op1.asObject0(), var_i.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_m.asObject0() ) ) );
                        SET_SUBSCRIPT_CONST( tmp_identifier.asObject0(), var_d.asObject0(), const_int_0, 0 );
                    }
                }
            }
        }
        frame_guard.setLineNumber( 136 );
        {
            PyObjectTempKeeper1 cmp1;
            if ( ( cmp1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_2, 2 ) ), RICH_COMPARE_BOOL_EQ( cmp1.asObject0(), PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_a.asObject0(), const_int_pos_2, 2 ) ).asObject0() ) ) )
            {
                frame_guard.setLineNumber( 137 );
                {
                    PyObjectTemporary tmp_identifier( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_2, 2 ) );
                    SET_SUBSCRIPT_CONST( tmp_identifier.asObject0(), var_d.asObject0(), const_int_pos_2, 2 );
                }
            }
            else
            {
                frame_guard.setLineNumber( 139 );
                {
                    PyObjectTempKeeper1 op1;
                    PyObjectTempKeeper1 op2;
                    PyObjectTempKeeper1 op3;
                    var_m.assign1( ( op3.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_1, 1 ) ), BINARY_OPERATION_SUB( op1.asObject0(), PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_a.asObject0(), const_int_pos_1, 1 ) ).asObject0() ) ) ), BINARY_OPERATION_DIV( op3.asObject0(), PyObjectTemporary( ( op2.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_2, 2 ) ), BINARY_OPERATION_SUB( op2.asObject0(), PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_a.asObject0(), const_int_pos_2, 2 ) ).asObject0() ) ) ).asObject0() ) ) );
                }
                frame_guard.setLineNumber( 140 );
                {
                    PyObjectTempKeeper0 op1;
                    PyObjectTempKeeper1 op2;
                    var_i.assign1( ( op2.assign( LOOKUP_SUBSCRIPT_CONST( par_a.asObject0(), const_int_pos_1, 1 ) ), BINARY_OPERATION_SUB( op2.asObject0(), PyObjectTemporary( ( op1.assign( var_m.asObject0() ), BINARY_OPERATION_MUL( op1.asObject0(), PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_a.asObject0(), const_int_pos_2, 2 ) ).asObject0() ) ) ).asObject0() ) ) );
                }
                frame_guard.setLineNumber( 141 );
                {
                    PyObjectTempKeeper1 op1;
                    PyObjectTempKeeper1 op2;
                    {
                        PyObjectTemporary tmp_identifier( ( op2.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( var_d.asObject0(), const_int_pos_1, 1 ) ), BINARY_OPERATION_SUB( op1.asObject0(), var_i.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_m.asObject0() ) ) );
                        SET_SUBSCRIPT_CONST( tmp_identifier.asObject0(), var_d.asObject0(), const_int_pos_2, 2 );
                    }
                }
            }
        }
        frame_guard.setLineNumber( 142 );
        {
            PyObjectTempKeeper1 cmp1;
            if ( ( cmp1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_3, 3 ) ), RICH_COMPARE_BOOL_EQ( cmp1.asObject0(), PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_a.asObject0(), const_int_pos_3, 3 ) ).asObject0() ) ) )
            {
                frame_guard.setLineNumber( 143 );
                {
                    PyObjectTemporary tmp_identifier( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_3, 3 ) );
                    SET_SUBSCRIPT_CONST( tmp_identifier.asObject0(), var_d.asObject0(), const_int_pos_3, 3 );
                }
            }
            else
            {
                frame_guard.setLineNumber( 145 );
                {
                    PyObjectTempKeeper1 op1;
                    PyObjectTempKeeper1 op2;
                    PyObjectTempKeeper1 op3;
                    var_m.assign1( ( op3.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_1, 1 ) ), BINARY_OPERATION_SUB( op1.asObject0(), PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_a.asObject0(), const_int_pos_1, 1 ) ).asObject0() ) ) ), BINARY_OPERATION_DIV( op3.asObject0(), PyObjectTemporary( ( op2.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_3, 3 ) ), BINARY_OPERATION_SUB( op2.asObject0(), PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_a.asObject0(), const_int_pos_3, 3 ) ).asObject0() ) ) ).asObject0() ) ) );
                }
                frame_guard.setLineNumber( 146 );
                {
                    PyObjectTempKeeper0 op1;
                    PyObjectTempKeeper1 op2;
                    var_i.assign1( ( op2.assign( LOOKUP_SUBSCRIPT_CONST( par_a.asObject0(), const_int_pos_1, 1 ) ), BINARY_OPERATION_SUB( op2.asObject0(), PyObjectTemporary( ( op1.assign( var_m.asObject0() ), BINARY_OPERATION_MUL( op1.asObject0(), PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_a.asObject0(), const_int_pos_3, 3 ) ).asObject0() ) ) ).asObject0() ) ) );
                }
                frame_guard.setLineNumber( 147 );
                {
                    PyObjectTempKeeper1 op1;
                    PyObjectTempKeeper1 op2;
                    {
                        PyObjectTemporary tmp_identifier( ( op2.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( var_d.asObject0(), const_int_pos_1, 1 ) ), BINARY_OPERATION_SUB( op1.asObject0(), var_i.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_m.asObject0() ) ) );
                        SET_SUBSCRIPT_CONST( tmp_identifier.asObject0(), var_d.asObject0(), const_int_pos_3, 3 );
                    }
                }
            }
        }
        frame_guard.setLineNumber( 148 );
        {
            PyObjectTempKeeper1 cmp1;
            if ( ( cmp1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_4, 4 ) ), RICH_COMPARE_BOOL_EQ( cmp1.asObject0(), PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_a.asObject0(), const_int_pos_4, 4 ) ).asObject0() ) ) )
            {
                frame_guard.setLineNumber( 149 );
                {
                    PyObjectTemporary tmp_identifier( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_4, 4 ) );
                    SET_SUBSCRIPT_CONST( tmp_identifier.asObject0(), var_d.asObject0(), const_int_pos_4, 4 );
                }
            }
            else
            {
                frame_guard.setLineNumber( 151 );
                {
                    PyObjectTempKeeper1 op1;
                    PyObjectTempKeeper1 op2;
                    PyObjectTempKeeper1 op3;
                    var_m.assign1( ( op3.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_1, 1 ) ), BINARY_OPERATION_SUB( op1.asObject0(), PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_a.asObject0(), const_int_pos_1, 1 ) ).asObject0() ) ) ), BINARY_OPERATION_DIV( op3.asObject0(), PyObjectTemporary( ( op2.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_4, 4 ) ), BINARY_OPERATION_SUB( op2.asObject0(), PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_a.asObject0(), const_int_pos_4, 4 ) ).asObject0() ) ) ).asObject0() ) ) );
                }
                frame_guard.setLineNumber( 152 );
                {
                    PyObjectTempKeeper0 op1;
                    PyObjectTempKeeper1 op2;
                    var_i.assign1( ( op2.assign( LOOKUP_SUBSCRIPT_CONST( par_a.asObject0(), const_int_pos_1, 1 ) ), BINARY_OPERATION_SUB( op2.asObject0(), PyObjectTemporary( ( op1.assign( var_m.asObject0() ), BINARY_OPERATION_MUL( op1.asObject0(), PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_a.asObject0(), const_int_pos_4, 4 ) ).asObject0() ) ) ).asObject0() ) ) );
                }
                frame_guard.setLineNumber( 153 );
                {
                    PyObjectTempKeeper1 op1;
                    PyObjectTempKeeper1 op2;
                    {
                        PyObjectTemporary tmp_identifier( ( op2.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( var_d.asObject0(), const_int_pos_1, 1 ) ), BINARY_OPERATION_SUB( op1.asObject0(), var_i.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_m.asObject0() ) ) );
                        SET_SUBSCRIPT_CONST( tmp_identifier.asObject0(), var_d.asObject0(), const_int_pos_4, 4 );
                    }
                }
            }
        }
        frame_guard.setLineNumber( 154 );
        {
            PyObjectTempKeeper0 call1;
            PyObjectTempKeeper0 call2;
            PyObjectTempKeeper0 call3;
            PyObjectTempKeeper0 call4;
            DECREASE_REFCOUNT( ( call1.assign( GET_MODULE_VALUE0( const_str_plain_draw_tri_point_up ) ), call2.assign( par_a.asObject0() ), call3.assign( par_b.asObject0() ), call4.assign( var_d.asObject0() ), CALL_FUNCTION_WITH_ARGS4( call1.asObject0(), call2.asObject0(), call3.asObject0(), call4.asObject0(), par_texture.asObject0() ) ) );
        }
        frame_guard.setLineNumber( 155 );
        {
            PyObjectTempKeeper0 call1;
            PyObjectTempKeeper0 call2;
            PyObjectTempKeeper0 call3;
            PyObjectTempKeeper0 call4;
            DECREASE_REFCOUNT( ( call1.assign( GET_MODULE_VALUE0( const_str_plain_draw_tri_point_down ) ), call2.assign( par_b.asObject0() ), call3.assign( var_d.asObject0() ), call4.assign( par_c.asObject0() ), CALL_FUNCTION_WITH_ARGS4( call1.asObject0(), call2.asObject0(), call3.asObject0(), call4.asObject0(), par_texture.asObject0() ) ) );
        }
    }
    catch ( PythonException &_exception )
    {
        if ( !_exception.hasTraceback() )
        {
            _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
        }
        else
        {
            _exception.addTraceback( frame_guard.getFrame0() );
        }

        Py_XDECREF( frame_guard.getFrame0()->f_locals );
        frame_guard.getFrame0()->f_locals = par_texture.updateLocalsDict( par_c.updateLocalsDict( par_b.updateLocalsDict( par_a.updateLocalsDict( var_i.updateLocalsDict( var_m.updateLocalsDict( var_d.updateLocalsDict( PyDict_New() ) ) ) ) ) ) );

        if ( frame_guard.getFrame0() == frame_function_9_draw_tri_split_of_module___main__ )
        {
           Py_DECREF( frame_function_9_draw_tri_split_of_module___main__ );
           frame_function_9_draw_tri_split_of_module___main__ = NULL;
        }

        _exception.toPython();
        return NULL;
    }
    return INCREASE_REFCOUNT( Py_None );
}
static PyObject *fparse_function_9_draw_tri_split_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, Py_ssize_t args_size, PyObject *kw )
{
    assert( kw == NULL || PyDict_Check( kw ) );

    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_size = kw ? PyDict_Size( kw ) : 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_found = 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_only_found = 0;
    Py_ssize_t args_given = args_size;
    PyObject *_python_par_a = NULL;
    PyObject *_python_par_b = NULL;
    PyObject *_python_par_c = NULL;
    PyObject *_python_par_texture = NULL;
    // Copy given dictionary values to the the respective variables:
    if ( kw_size > 0 )
    {
        Py_ssize_t ppos = 0;
        PyObject *key, *value;

        while( PyDict_Next( kw, &ppos, &key, &value ) )
        {
#if PYTHON_VERSION < 300
            if (unlikely( !PyString_Check( key ) && !PyUnicode_Check( key ) ))
#else
            if (unlikely( !PyUnicode_Check( key ) ))
#endif
            {
                PyErr_Format( PyExc_TypeError, "draw_tri_split() keywords must be strings" );
                goto error_exit;
            }

            NUITKA_MAY_BE_UNUSED bool found = false;

            Py_INCREF( key );
            Py_INCREF( value );

            // Quick path, could be our value.
            if ( found == false && const_str_plain_a == key )
            {
                assert( _python_par_a == NULL );
                _python_par_a = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_b == key )
            {
                assert( _python_par_b == NULL );
                _python_par_b = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_c == key )
            {
                assert( _python_par_c == NULL );
                _python_par_c = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_texture == key )
            {
                assert( _python_par_texture == NULL );
                _python_par_texture = value;

                found = true;
                kw_found += 1;
            }

            // Slow path, compare against all parameter names.
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_a, key ) )
            {
                assert( _python_par_a == NULL );
                _python_par_a = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_b, key ) )
            {
                assert( _python_par_b == NULL );
                _python_par_b = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_c, key ) )
            {
                assert( _python_par_c == NULL );
                _python_par_c = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_texture, key ) )
            {
                assert( _python_par_texture == NULL );
                _python_par_texture = value;

                found = true;
                kw_found += 1;
            }


            Py_DECREF( key );

            if ( found == false )
            {
               Py_DECREF( value );

               PyErr_Format(
                   PyExc_TypeError,
                   "draw_tri_split() got an unexpected keyword argument '%s'",
                   Nuitka_String_Check( key ) ? Nuitka_String_AsString( key ) : "<non-string>"
               );

               goto error_exit;
            }
        }

#if PYTHON_VERSION < 300
        assert( kw_found == kw_size );
        assert( kw_only_found == 0 );
#endif
    }

    // Check if too many arguments were given in case of non star args
    if (unlikely( args_given > 4 ))
    {
#if PYTHON_VERSION < 270
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_size );
#elif PYTHON_VERSION < 330
        ERROR_TOO_MANY_ARGUMENTS( self, args_given + kw_found );
#else
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_only_found );
#endif
        goto error_exit;
    }


    // Copy normal parameter values given as part of the args list to the respective variables:

    if (likely( 0 < args_given ))
    {
         if (unlikely( _python_par_a != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 0 );
             goto error_exit;
         }

        _python_par_a = INCREASE_REFCOUNT( args[ 0 ] );
    }
    else if ( _python_par_a == NULL )
    {
        if ( 0 + self->m_defaults_given >= 4  )
        {
            _python_par_a = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 0 - 4 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 1 < args_given ))
    {
         if (unlikely( _python_par_b != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 1 );
             goto error_exit;
         }

        _python_par_b = INCREASE_REFCOUNT( args[ 1 ] );
    }
    else if ( _python_par_b == NULL )
    {
        if ( 1 + self->m_defaults_given >= 4  )
        {
            _python_par_b = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 1 - 4 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 2 < args_given ))
    {
         if (unlikely( _python_par_c != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 2 );
             goto error_exit;
         }

        _python_par_c = INCREASE_REFCOUNT( args[ 2 ] );
    }
    else if ( _python_par_c == NULL )
    {
        if ( 2 + self->m_defaults_given >= 4  )
        {
            _python_par_c = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 2 - 4 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 3 < args_given ))
    {
         if (unlikely( _python_par_texture != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 3 );
             goto error_exit;
         }

        _python_par_texture = INCREASE_REFCOUNT( args[ 3 ] );
    }
    else if ( _python_par_texture == NULL )
    {
        if ( 3 + self->m_defaults_given >= 4  )
        {
            _python_par_texture = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 3 - 4 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }

#if PYTHON_VERSION >= 330
    if (unlikely( _python_par_a == NULL || _python_par_b == NULL || _python_par_c == NULL || _python_par_texture == NULL ))
    {
        PyObject *values[] = { _python_par_a, _python_par_b, _python_par_c, _python_par_texture };
        ERROR_TOO_FEW_ARGUMENTS( self, values );

        goto error_exit;
    }
#endif


    return impl_function_9_draw_tri_split_of_module___main__( self, _python_par_a, _python_par_b, _python_par_c, _python_par_texture );

error_exit:;

    Py_XDECREF( _python_par_a );
    Py_XDECREF( _python_par_b );
    Py_XDECREF( _python_par_c );
    Py_XDECREF( _python_par_texture );

    return NULL;
}

static PyObject *dparse_function_9_draw_tri_split_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, int size )
{
    if ( size == 4 )
    {
        return impl_function_9_draw_tri_split_of_module___main__( self, INCREASE_REFCOUNT( args[ 0 ] ), INCREASE_REFCOUNT( args[ 1 ] ), INCREASE_REFCOUNT( args[ 2 ] ), INCREASE_REFCOUNT( args[ 3 ] ) );
    }
    else
    {
        PyObject *result = fparse_function_9_draw_tri_split_of_module___main__( self, args, size, NULL );
        return result;
    }

}



static PyObject *impl_function_10_draw_line_of_module___main__( Nuitka_FunctionObject *self, PyObject *_python_par_x1, PyObject *_python_par_y1, PyObject *_python_par_z1, PyObject *_python_par_u1, PyObject *_python_par_v1, PyObject *_python_par_x2, PyObject *_python_par_y2, PyObject *_python_par_z2, PyObject *_python_par_u2, PyObject *_python_par_v2, PyObject *_python_par_texture )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par_x1( const_str_plain_x1, _python_par_x1 );
    PyObjectLocalParameterVariableNoDel par_y1( const_str_plain_y1, _python_par_y1 );
    PyObjectLocalParameterVariableNoDel par_z1( const_str_plain_z1, _python_par_z1 );
    PyObjectLocalParameterVariableNoDel par_u1( const_str_plain_u1, _python_par_u1 );
    PyObjectLocalParameterVariableNoDel par_v1( const_str_plain_v1, _python_par_v1 );
    PyObjectLocalParameterVariableNoDel par_x2( const_str_plain_x2, _python_par_x2 );
    PyObjectLocalParameterVariableNoDel par_y2( const_str_plain_y2, _python_par_y2 );
    PyObjectLocalParameterVariableNoDel par_z2( const_str_plain_z2, _python_par_z2 );
    PyObjectLocalParameterVariableNoDel par_u2( const_str_plain_u2, _python_par_u2 );
    PyObjectLocalParameterVariableNoDel par_v2( const_str_plain_v2, _python_par_v2 );
    PyObjectLocalParameterVariableNoDel par_texture( const_str_plain_texture, _python_par_texture );
    PyObjectLocalVariable var_x( const_str_plain_x );
    PyObjectLocalVariable var_y( const_str_plain_y );
    PyObjectLocalVariable var_z( const_str_plain_z );
    PyObjectLocalVariable var_u( const_str_plain_u );
    PyObjectLocalVariable var_v( const_str_plain_v );
    PyObjectLocalVariable var_w( const_str_plain_w );
    PyObjectLocalVariable var_dx( const_str_plain_dx );
    PyObjectLocalVariable var_dy( const_str_plain_dy );
    PyObjectLocalVariable var_dz( const_str_plain_dz );
    PyObjectLocalVariable var_du( const_str_plain_du );
    PyObjectLocalVariable var_dv( const_str_plain_dv );
    PyObjectTempVariable tmp_tuple_unpack_1__source_iter;
    PyObjectTempVariable tmp_tuple_unpack_1__element_1;
    PyObjectTempVariable tmp_tuple_unpack_1__element_2;
    PyObjectTempVariable tmp_tuple_unpack_1__element_3;
    PyObjectTempVariable tmp_tuple_unpack_1__element_4;
    PyObjectTempVariable tmp_tuple_unpack_1__element_5;

    // Actual function code.
    static PyFrameObject *frame_function_10_draw_line_of_module___main__ = NULL;

    if ( isFrameUnusable( frame_function_10_draw_line_of_module___main__ ) )
    {
        if ( frame_function_10_draw_line_of_module___main__ )
        {
#if _DEBUG_REFRAME
            puts( "reframe for function_10_draw_line_of_module___main__" );
#endif
            Py_DECREF( frame_function_10_draw_line_of_module___main__ );
        }

        frame_function_10_draw_line_of_module___main__ = MAKE_FRAME( codeobj_1a8c48354bcf048e28bc37ace890bb84, module___main__ );
    }

    FrameGuard frame_guard( frame_function_10_draw_line_of_module___main__ );
    try
    {
        assert( Py_REFCNT( frame_function_10_draw_line_of_module___main__ ) == 2 ); // Frame stack
        frame_guard.setLineNumber( 159 );
        PythonExceptionKeeper _caught_1;
#if PYTHON_VERSION < 300
        int _at_lineno_1 = 0;
#endif


        try
        {
            // Tried block:
            {
                PyObjectTempKeeper0 make_tuple1;
                PyObjectTempKeeper0 make_tuple2;
                PyObjectTempKeeper0 make_tuple3;
                PyObjectTempKeeper0 make_tuple4;
                tmp_tuple_unpack_1__source_iter.assign1( MAKE_ITERATOR( PyObjectTemporary( ( make_tuple1.assign( par_x1.asObject0() ), make_tuple2.assign( par_y1.asObject0() ), make_tuple3.assign( par_z1.asObject0() ), make_tuple4.assign( par_u1.asObject0() ), MAKE_TUPLE5( make_tuple1.asObject0(), make_tuple2.asObject0(), make_tuple3.asObject0(), make_tuple4.asObject0(), par_v1.asObject0() ) ) ).asObject0() ) );
            }
            tmp_tuple_unpack_1__element_1.assign1( UNPACK_NEXT( tmp_tuple_unpack_1__source_iter.asObject0(), 0 ) );
            tmp_tuple_unpack_1__element_2.assign1( UNPACK_NEXT( tmp_tuple_unpack_1__source_iter.asObject0(), 1 ) );
            tmp_tuple_unpack_1__element_3.assign1( UNPACK_NEXT( tmp_tuple_unpack_1__source_iter.asObject0(), 2 ) );
            tmp_tuple_unpack_1__element_4.assign1( UNPACK_NEXT( tmp_tuple_unpack_1__source_iter.asObject0(), 3 ) );
            tmp_tuple_unpack_1__element_5.assign1( UNPACK_NEXT( tmp_tuple_unpack_1__source_iter.asObject0(), 4 ) );
            UNPACK_ITERATOR_CHECK( tmp_tuple_unpack_1__source_iter.asObject0(), 5 );
            var_x.assign0( tmp_tuple_unpack_1__element_1.asObject0() );
            var_y.assign0( tmp_tuple_unpack_1__element_2.asObject0() );
            var_z.assign0( tmp_tuple_unpack_1__element_3.asObject0() );
            var_u.assign0( tmp_tuple_unpack_1__element_4.asObject0() );
            var_v.assign0( tmp_tuple_unpack_1__element_5.asObject0() );
        }
        catch ( PythonException &_exception )
        {
#if PYTHON_VERSION >= 300
            if ( !_exception.hasTraceback() )
            {
                _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
            }
            else
            {
                _exception.addTraceback( frame_guard.getFrame0() );
            }
#else
            _at_lineno_1 = frame_guard.getLineNumber();
#endif

            _caught_1.save( _exception );

#if PYTHON_VERSION >= 300
            frame_guard.preserveExistingException();

            _exception.toExceptionHandler();
#endif
        }

        // Final block:
        tmp_tuple_unpack_1__source_iter.del( true );
        tmp_tuple_unpack_1__element_1.del( true );
        tmp_tuple_unpack_1__element_2.del( true );
        tmp_tuple_unpack_1__element_3.del( true );
        tmp_tuple_unpack_1__element_4.del( true );
        tmp_tuple_unpack_1__element_5.del( true );
#if PYTHON_VERSION < 300
        if ( _at_lineno_1 != 0 )
        {
           frame_guard.setLineNumber( _at_lineno_1 );
        }
#endif
        _caught_1.rethrow();
        // Final end
        frame_guard.setLineNumber( 160 );
        {
            PyObjectTempKeeper0 op1;
            var_w.assign1( CALL_FUNCTION_WITH_ARGS1( LOOKUP_BUILTIN( const_str_plain_abs ), PyObjectTemporary( ( op1.assign( par_x2.asObject0() ), BINARY_OPERATION_SUB( op1.asObject0(), par_x1.asObject0() ) ) ).asObject0() ) );
        }
        frame_guard.setLineNumber( 161 );
        if ( (!( CHECK_IF_TRUE( var_w.asObject0() ) )) )
        {
            return INCREASE_REFCOUNT( Py_None );
        }
        frame_guard.setLineNumber( 163 );
        {
            PyObjectTempKeeper0 cmp1;
            if ( ( RICH_COMPARE_BOOL_LT( var_y.asObject0(), const_int_0 ) || ( cmp1.assign( var_y.asObject0() ), RICH_COMPARE_BOOL_GE( cmp1.asObject0(), GET_MODULE_VALUE0( const_str_plain_s_h ) ) ) ) )
            {
                return INCREASE_REFCOUNT( Py_None );
            }
        }
        var_dx.assign0( const_int_pos_1 );
        var_dy.assign0( const_int_0 );
        frame_guard.setLineNumber( 167 );
        {
            PyObjectTempKeeper0 op1;
            PyObjectTempKeeper1 op2;
            var_dz.assign1( ( op2.assign( ( op1.assign( par_z2.asObject0() ), BINARY_OPERATION_SUB( op1.asObject0(), par_z1.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_w.asObject0() ) ) );
        }
        frame_guard.setLineNumber( 168 );
        {
            PyObjectTempKeeper0 op1;
            PyObjectTempKeeper1 op2;
            var_du.assign1( ( op2.assign( ( op1.assign( par_u2.asObject0() ), BINARY_OPERATION_SUB( op1.asObject0(), par_u1.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_w.asObject0() ) ) );
        }
        frame_guard.setLineNumber( 169 );
        {
            PyObjectTempKeeper0 op1;
            PyObjectTempKeeper1 op2;
            var_dv.assign1( ( op2.assign( ( op1.assign( par_v2.asObject0() ), BINARY_OPERATION_SUB( op1.asObject0(), par_v1.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_w.asObject0() ) ) );
        }
        while( true )
        {
            frame_guard.setLineNumber( 170 );
            {
                PyObjectTempKeeper0 cmp1;
                if ( (!( ( cmp1.assign( var_x.asObject0() ), RICH_COMPARE_BOOL_LT( cmp1.asObject0(), par_x2.asObject0() ) ) )) )
                {
                    break;
                }
            }
            frame_guard.setLineNumber( 171 );
            {
                PyObjectTempKeeper0 cmp1;
                if ( ( cmp1.assign( var_x.asObject0() ), RICH_COMPARE_BOOL_GE( cmp1.asObject0(), GET_MODULE_VALUE0( const_str_plain_s_w ) ) ) )
                {
                    return INCREASE_REFCOUNT( Py_None );
                }
            }
            frame_guard.setLineNumber( 173 );
            if ( RICH_COMPARE_BOOL_GE( var_x.asObject0(), const_int_0 ) )
            {
                frame_guard.setLineNumber( 174 );
                {
                    PyObjectTempKeeper0 call1;
                    PyObjectTempKeeper1 call2;
                    PyObjectTempKeeper1 call3;
                    PyObjectTempKeeper0 call4;
                    PyObjectTempKeeper0 call5;
                    PyObjectTempKeeper0 call6;
                    DECREASE_REFCOUNT( ( call1.assign( GET_MODULE_VALUE0( const_str_plain_draw_point ) ), call2.assign( TO_INT( var_x.asObject0() ) ), call3.assign( TO_INT( var_y.asObject0() ) ), call4.assign( var_z.asObject0() ), call5.assign( var_u.asObject0() ), call6.assign( var_v.asObject0() ), CALL_FUNCTION_WITH_ARGS6( call1.asObject0(), call2.asObject0(), call3.asObject0(), call4.asObject0(), call5.asObject0(), call6.asObject0(), par_texture.asObject0() ) ) );
                }
            }
            frame_guard.setLineNumber( 175 );
            PyObject *tmp_inplace_assign_1__inplace_start = var_x.asObject0();
            PyObject *_tmp_inplace_assign_1__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_1__inplace_end = ( op1.assign( tmp_inplace_assign_1__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_dx.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_1__inplace_end( _tmp_inplace_assign_1__inplace_end );
            if ( ( tmp_inplace_assign_1__inplace_start != tmp_inplace_assign_1__inplace_end.asObject0() ) )
            {
                var_x.assign0( tmp_inplace_assign_1__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 176 );
            PyObject *tmp_inplace_assign_2__inplace_start = var_y.asObject0();
            PyObject *_tmp_inplace_assign_2__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_2__inplace_end = ( op1.assign( tmp_inplace_assign_2__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_dy.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_2__inplace_end( _tmp_inplace_assign_2__inplace_end );
            if ( ( tmp_inplace_assign_2__inplace_start != tmp_inplace_assign_2__inplace_end.asObject0() ) )
            {
                var_y.assign0( tmp_inplace_assign_2__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 177 );
            PyObject *tmp_inplace_assign_3__inplace_start = var_z.asObject0();
            PyObject *_tmp_inplace_assign_3__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_3__inplace_end = ( op1.assign( tmp_inplace_assign_3__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_dz.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_3__inplace_end( _tmp_inplace_assign_3__inplace_end );
            if ( ( tmp_inplace_assign_3__inplace_start != tmp_inplace_assign_3__inplace_end.asObject0() ) )
            {
                var_z.assign0( tmp_inplace_assign_3__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 178 );
            PyObject *tmp_inplace_assign_4__inplace_start = var_u.asObject0();
            PyObject *_tmp_inplace_assign_4__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_4__inplace_end = ( op1.assign( tmp_inplace_assign_4__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_du.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_4__inplace_end( _tmp_inplace_assign_4__inplace_end );
            if ( ( tmp_inplace_assign_4__inplace_start != tmp_inplace_assign_4__inplace_end.asObject0() ) )
            {
                var_u.assign0( tmp_inplace_assign_4__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 179 );
            PyObject *tmp_inplace_assign_5__inplace_start = var_v.asObject0();
            PyObject *_tmp_inplace_assign_5__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_5__inplace_end = ( op1.assign( tmp_inplace_assign_5__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_dv.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_5__inplace_end( _tmp_inplace_assign_5__inplace_end );
            if ( ( tmp_inplace_assign_5__inplace_start != tmp_inplace_assign_5__inplace_end.asObject0() ) )
            {
                var_v.assign0( tmp_inplace_assign_5__inplace_end.asObject0() );
            }

            CONSIDER_THREADING();
        }
    }
    catch ( PythonException &_exception )
    {
        if ( !_exception.hasTraceback() )
        {
            _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
        }
        else
        {
            _exception.addTraceback( frame_guard.getFrame0() );
        }

        Py_XDECREF( frame_guard.getFrame0()->f_locals );
        frame_guard.getFrame0()->f_locals = par_texture.updateLocalsDict( par_v2.updateLocalsDict( par_u2.updateLocalsDict( par_z2.updateLocalsDict( par_y2.updateLocalsDict( par_x2.updateLocalsDict( par_v1.updateLocalsDict( par_u1.updateLocalsDict( par_z1.updateLocalsDict( par_y1.updateLocalsDict( par_x1.updateLocalsDict( var_dv.updateLocalsDict( var_du.updateLocalsDict( var_dz.updateLocalsDict( var_dy.updateLocalsDict( var_dx.updateLocalsDict( var_w.updateLocalsDict( var_v.updateLocalsDict( var_u.updateLocalsDict( var_z.updateLocalsDict( var_y.updateLocalsDict( var_x.updateLocalsDict( PyDict_New() ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) );

        if ( frame_guard.getFrame0() == frame_function_10_draw_line_of_module___main__ )
        {
           Py_DECREF( frame_function_10_draw_line_of_module___main__ );
           frame_function_10_draw_line_of_module___main__ = NULL;
        }

        _exception.toPython();
        return NULL;
    }
    return INCREASE_REFCOUNT( Py_None );
}
static PyObject *fparse_function_10_draw_line_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, Py_ssize_t args_size, PyObject *kw )
{
    assert( kw == NULL || PyDict_Check( kw ) );

    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_size = kw ? PyDict_Size( kw ) : 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_found = 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_only_found = 0;
    Py_ssize_t args_given = args_size;
    PyObject *_python_par_x1 = NULL;
    PyObject *_python_par_y1 = NULL;
    PyObject *_python_par_z1 = NULL;
    PyObject *_python_par_u1 = NULL;
    PyObject *_python_par_v1 = NULL;
    PyObject *_python_par_x2 = NULL;
    PyObject *_python_par_y2 = NULL;
    PyObject *_python_par_z2 = NULL;
    PyObject *_python_par_u2 = NULL;
    PyObject *_python_par_v2 = NULL;
    PyObject *_python_par_texture = NULL;
    // Copy given dictionary values to the the respective variables:
    if ( kw_size > 0 )
    {
        Py_ssize_t ppos = 0;
        PyObject *key, *value;

        while( PyDict_Next( kw, &ppos, &key, &value ) )
        {
#if PYTHON_VERSION < 300
            if (unlikely( !PyString_Check( key ) && !PyUnicode_Check( key ) ))
#else
            if (unlikely( !PyUnicode_Check( key ) ))
#endif
            {
                PyErr_Format( PyExc_TypeError, "draw_line() keywords must be strings" );
                goto error_exit;
            }

            NUITKA_MAY_BE_UNUSED bool found = false;

            Py_INCREF( key );
            Py_INCREF( value );

            // Quick path, could be our value.
            if ( found == false && const_str_plain_x1 == key )
            {
                assert( _python_par_x1 == NULL );
                _python_par_x1 = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_y1 == key )
            {
                assert( _python_par_y1 == NULL );
                _python_par_y1 = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_z1 == key )
            {
                assert( _python_par_z1 == NULL );
                _python_par_z1 = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_u1 == key )
            {
                assert( _python_par_u1 == NULL );
                _python_par_u1 = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_v1 == key )
            {
                assert( _python_par_v1 == NULL );
                _python_par_v1 = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_x2 == key )
            {
                assert( _python_par_x2 == NULL );
                _python_par_x2 = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_y2 == key )
            {
                assert( _python_par_y2 == NULL );
                _python_par_y2 = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_z2 == key )
            {
                assert( _python_par_z2 == NULL );
                _python_par_z2 = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_u2 == key )
            {
                assert( _python_par_u2 == NULL );
                _python_par_u2 = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_v2 == key )
            {
                assert( _python_par_v2 == NULL );
                _python_par_v2 = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_texture == key )
            {
                assert( _python_par_texture == NULL );
                _python_par_texture = value;

                found = true;
                kw_found += 1;
            }

            // Slow path, compare against all parameter names.
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_x1, key ) )
            {
                assert( _python_par_x1 == NULL );
                _python_par_x1 = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_y1, key ) )
            {
                assert( _python_par_y1 == NULL );
                _python_par_y1 = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_z1, key ) )
            {
                assert( _python_par_z1 == NULL );
                _python_par_z1 = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_u1, key ) )
            {
                assert( _python_par_u1 == NULL );
                _python_par_u1 = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_v1, key ) )
            {
                assert( _python_par_v1 == NULL );
                _python_par_v1 = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_x2, key ) )
            {
                assert( _python_par_x2 == NULL );
                _python_par_x2 = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_y2, key ) )
            {
                assert( _python_par_y2 == NULL );
                _python_par_y2 = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_z2, key ) )
            {
                assert( _python_par_z2 == NULL );
                _python_par_z2 = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_u2, key ) )
            {
                assert( _python_par_u2 == NULL );
                _python_par_u2 = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_v2, key ) )
            {
                assert( _python_par_v2 == NULL );
                _python_par_v2 = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_texture, key ) )
            {
                assert( _python_par_texture == NULL );
                _python_par_texture = value;

                found = true;
                kw_found += 1;
            }


            Py_DECREF( key );

            if ( found == false )
            {
               Py_DECREF( value );

               PyErr_Format(
                   PyExc_TypeError,
                   "draw_line() got an unexpected keyword argument '%s'",
                   Nuitka_String_Check( key ) ? Nuitka_String_AsString( key ) : "<non-string>"
               );

               goto error_exit;
            }
        }

#if PYTHON_VERSION < 300
        assert( kw_found == kw_size );
        assert( kw_only_found == 0 );
#endif
    }

    // Check if too many arguments were given in case of non star args
    if (unlikely( args_given > 11 ))
    {
#if PYTHON_VERSION < 270
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_size );
#elif PYTHON_VERSION < 330
        ERROR_TOO_MANY_ARGUMENTS( self, args_given + kw_found );
#else
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_only_found );
#endif
        goto error_exit;
    }


    // Copy normal parameter values given as part of the args list to the respective variables:

    if (likely( 0 < args_given ))
    {
         if (unlikely( _python_par_x1 != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 0 );
             goto error_exit;
         }

        _python_par_x1 = INCREASE_REFCOUNT( args[ 0 ] );
    }
    else if ( _python_par_x1 == NULL )
    {
        if ( 0 + self->m_defaults_given >= 11  )
        {
            _python_par_x1 = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 0 - 11 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 1 < args_given ))
    {
         if (unlikely( _python_par_y1 != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 1 );
             goto error_exit;
         }

        _python_par_y1 = INCREASE_REFCOUNT( args[ 1 ] );
    }
    else if ( _python_par_y1 == NULL )
    {
        if ( 1 + self->m_defaults_given >= 11  )
        {
            _python_par_y1 = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 1 - 11 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 2 < args_given ))
    {
         if (unlikely( _python_par_z1 != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 2 );
             goto error_exit;
         }

        _python_par_z1 = INCREASE_REFCOUNT( args[ 2 ] );
    }
    else if ( _python_par_z1 == NULL )
    {
        if ( 2 + self->m_defaults_given >= 11  )
        {
            _python_par_z1 = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 2 - 11 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 3 < args_given ))
    {
         if (unlikely( _python_par_u1 != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 3 );
             goto error_exit;
         }

        _python_par_u1 = INCREASE_REFCOUNT( args[ 3 ] );
    }
    else if ( _python_par_u1 == NULL )
    {
        if ( 3 + self->m_defaults_given >= 11  )
        {
            _python_par_u1 = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 3 - 11 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 4 < args_given ))
    {
         if (unlikely( _python_par_v1 != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 4 );
             goto error_exit;
         }

        _python_par_v1 = INCREASE_REFCOUNT( args[ 4 ] );
    }
    else if ( _python_par_v1 == NULL )
    {
        if ( 4 + self->m_defaults_given >= 11  )
        {
            _python_par_v1 = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 4 - 11 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 5 < args_given ))
    {
         if (unlikely( _python_par_x2 != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 5 );
             goto error_exit;
         }

        _python_par_x2 = INCREASE_REFCOUNT( args[ 5 ] );
    }
    else if ( _python_par_x2 == NULL )
    {
        if ( 5 + self->m_defaults_given >= 11  )
        {
            _python_par_x2 = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 5 - 11 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 6 < args_given ))
    {
         if (unlikely( _python_par_y2 != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 6 );
             goto error_exit;
         }

        _python_par_y2 = INCREASE_REFCOUNT( args[ 6 ] );
    }
    else if ( _python_par_y2 == NULL )
    {
        if ( 6 + self->m_defaults_given >= 11  )
        {
            _python_par_y2 = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 6 - 11 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 7 < args_given ))
    {
         if (unlikely( _python_par_z2 != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 7 );
             goto error_exit;
         }

        _python_par_z2 = INCREASE_REFCOUNT( args[ 7 ] );
    }
    else if ( _python_par_z2 == NULL )
    {
        if ( 7 + self->m_defaults_given >= 11  )
        {
            _python_par_z2 = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 7 - 11 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 8 < args_given ))
    {
         if (unlikely( _python_par_u2 != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 8 );
             goto error_exit;
         }

        _python_par_u2 = INCREASE_REFCOUNT( args[ 8 ] );
    }
    else if ( _python_par_u2 == NULL )
    {
        if ( 8 + self->m_defaults_given >= 11  )
        {
            _python_par_u2 = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 8 - 11 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 9 < args_given ))
    {
         if (unlikely( _python_par_v2 != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 9 );
             goto error_exit;
         }

        _python_par_v2 = INCREASE_REFCOUNT( args[ 9 ] );
    }
    else if ( _python_par_v2 == NULL )
    {
        if ( 9 + self->m_defaults_given >= 11  )
        {
            _python_par_v2 = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 9 - 11 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 10 < args_given ))
    {
         if (unlikely( _python_par_texture != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 10 );
             goto error_exit;
         }

        _python_par_texture = INCREASE_REFCOUNT( args[ 10 ] );
    }
    else if ( _python_par_texture == NULL )
    {
        if ( 10 + self->m_defaults_given >= 11  )
        {
            _python_par_texture = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 10 - 11 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }

#if PYTHON_VERSION >= 330
    if (unlikely( _python_par_x1 == NULL || _python_par_y1 == NULL || _python_par_z1 == NULL || _python_par_u1 == NULL || _python_par_v1 == NULL || _python_par_x2 == NULL || _python_par_y2 == NULL || _python_par_z2 == NULL || _python_par_u2 == NULL || _python_par_v2 == NULL || _python_par_texture == NULL ))
    {
        PyObject *values[] = { _python_par_x1, _python_par_y1, _python_par_z1, _python_par_u1, _python_par_v1, _python_par_x2, _python_par_y2, _python_par_z2, _python_par_u2, _python_par_v2, _python_par_texture };
        ERROR_TOO_FEW_ARGUMENTS( self, values );

        goto error_exit;
    }
#endif


    return impl_function_10_draw_line_of_module___main__( self, _python_par_x1, _python_par_y1, _python_par_z1, _python_par_u1, _python_par_v1, _python_par_x2, _python_par_y2, _python_par_z2, _python_par_u2, _python_par_v2, _python_par_texture );

error_exit:;

    Py_XDECREF( _python_par_x1 );
    Py_XDECREF( _python_par_y1 );
    Py_XDECREF( _python_par_z1 );
    Py_XDECREF( _python_par_u1 );
    Py_XDECREF( _python_par_v1 );
    Py_XDECREF( _python_par_x2 );
    Py_XDECREF( _python_par_y2 );
    Py_XDECREF( _python_par_z2 );
    Py_XDECREF( _python_par_u2 );
    Py_XDECREF( _python_par_v2 );
    Py_XDECREF( _python_par_texture );

    return NULL;
}

static PyObject *dparse_function_10_draw_line_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, int size )
{
    if ( size == 11 )
    {
        return impl_function_10_draw_line_of_module___main__( self, INCREASE_REFCOUNT( args[ 0 ] ), INCREASE_REFCOUNT( args[ 1 ] ), INCREASE_REFCOUNT( args[ 2 ] ), INCREASE_REFCOUNT( args[ 3 ] ), INCREASE_REFCOUNT( args[ 4 ] ), INCREASE_REFCOUNT( args[ 5 ] ), INCREASE_REFCOUNT( args[ 6 ] ), INCREASE_REFCOUNT( args[ 7 ] ), INCREASE_REFCOUNT( args[ 8 ] ), INCREASE_REFCOUNT( args[ 9 ] ), INCREASE_REFCOUNT( args[ 10 ] ) );
    }
    else
    {
        PyObject *result = fparse_function_10_draw_line_of_module___main__( self, args, size, NULL );
        return result;
    }

}



static PyObject *impl_function_11_draw_tri_point_up_of_module___main__( Nuitka_FunctionObject *self, PyObject *_python_par_a, PyObject *_python_par_b, PyObject *_python_par_c, PyObject *_python_par_texture )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par_a( const_str_plain_a, _python_par_a );
    PyObjectLocalParameterVariableNoDel par_b( const_str_plain_b, _python_par_b );
    PyObjectLocalParameterVariableNoDel par_c( const_str_plain_c, _python_par_c );
    PyObjectLocalParameterVariableNoDel par_texture( const_str_plain_texture, _python_par_texture );
    PyObjectLocalVariable var_x( const_str_plain_x );
    PyObjectLocalVariable var_y( const_str_plain_y );
    PyObjectLocalVariable var_z( const_str_plain_z );
    PyObjectLocalVariable var_u( const_str_plain_u );
    PyObjectLocalVariable var_v( const_str_plain_v );
    PyObjectLocalVariable var_ex( const_str_plain_ex );
    PyObjectLocalVariable var_ey( const_str_plain_ey );
    PyObjectLocalVariable var_ez( const_str_plain_ez );
    PyObjectLocalVariable var_eu( const_str_plain_eu );
    PyObjectLocalVariable var_ev( const_str_plain_ev );
    PyObjectLocalVariable var_ydist( const_str_plain_ydist );
    PyObjectLocalVariable var_dx1( const_str_plain_dx1 );
    PyObjectLocalVariable var_dx2( const_str_plain_dx2 );
    PyObjectLocalVariable var_dy1( const_str_plain_dy1 );
    PyObjectLocalVariable var_dy2( const_str_plain_dy2 );
    PyObjectLocalVariable var_dz1( const_str_plain_dz1 );
    PyObjectLocalVariable var_dz2( const_str_plain_dz2 );
    PyObjectLocalVariable var_du1( const_str_plain_du1 );
    PyObjectLocalVariable var_du2( const_str_plain_du2 );
    PyObjectLocalVariable var_dv1( const_str_plain_dv1 );
    PyObjectLocalVariable var_dv2( const_str_plain_dv2 );
    PyObjectTempVariable tmp_tuple_unpack_1__source_iter;
    PyObjectTempVariable tmp_tuple_unpack_1__element_1;
    PyObjectTempVariable tmp_tuple_unpack_1__element_2;
    PyObjectTempVariable tmp_tuple_unpack_2__source_iter;
    PyObjectTempVariable tmp_tuple_unpack_2__element_1;
    PyObjectTempVariable tmp_tuple_unpack_2__element_2;
    PyObjectTempVariable tmp_tuple_unpack_2__element_3;
    PyObjectTempVariable tmp_tuple_unpack_2__element_4;
    PyObjectTempVariable tmp_tuple_unpack_2__element_5;
    PyObjectTempVariable tmp_tuple_unpack_3__source_iter;
    PyObjectTempVariable tmp_tuple_unpack_3__element_1;
    PyObjectTempVariable tmp_tuple_unpack_3__element_2;
    PyObjectTempVariable tmp_tuple_unpack_3__element_3;
    PyObjectTempVariable tmp_tuple_unpack_3__element_4;
    PyObjectTempVariable tmp_tuple_unpack_3__element_5;
    PyObjectTempVariable tmp_tuple_unpack_4__source_iter;
    PyObjectTempVariable tmp_tuple_unpack_4__element_1;
    PyObjectTempVariable tmp_tuple_unpack_4__element_2;

    // Actual function code.
    static PyFrameObject *frame_function_11_draw_tri_point_up_of_module___main__ = NULL;

    if ( isFrameUnusable( frame_function_11_draw_tri_point_up_of_module___main__ ) )
    {
        if ( frame_function_11_draw_tri_point_up_of_module___main__ )
        {
#if _DEBUG_REFRAME
            puts( "reframe for function_11_draw_tri_point_up_of_module___main__" );
#endif
            Py_DECREF( frame_function_11_draw_tri_point_up_of_module___main__ );
        }

        frame_function_11_draw_tri_point_up_of_module___main__ = MAKE_FRAME( codeobj_b33b08247770f45a6b36e27b6c4b0eca, module___main__ );
    }

    FrameGuard frame_guard( frame_function_11_draw_tri_point_up_of_module___main__ );
    try
    {
        assert( Py_REFCNT( frame_function_11_draw_tri_point_up_of_module___main__ ) == 2 ); // Frame stack
        frame_guard.setLineNumber( 183 );
        PythonExceptionKeeper _caught_1;
#if PYTHON_VERSION < 300
        int _at_lineno_1 = 0;
#endif


        try
        {
            // Tried block:
            {
                PyObjectTempKeeper0 make_list1;
                tmp_tuple_unpack_1__source_iter.assign1( MAKE_ITERATOR( PyObjectTemporary( CALL_FUNCTION( LOOKUP_BUILTIN( const_str_plain_sorted ), PyObjectTemporary( MAKE_TUPLE1( PyObjectTemporary( ( make_list1.assign( par_b.asObject0() ), MAKE_LIST2( make_list1.asObject1(), par_c.asObject1() ) ) ).asObject0() ) ).asObject0(), PyObjectTemporary( MAKE_DICT1( PyObjectTemporary( MAKE_FUNCTION_lambda_1_lambda_of_function_11_draw_tri_point_up_of_module___main__(  ) ).asObject0(), const_str_plain_key ) ).asObject0() ) ).asObject0() ) );
            }
            tmp_tuple_unpack_1__element_1.assign1( UNPACK_NEXT( tmp_tuple_unpack_1__source_iter.asObject0(), 0 ) );
            tmp_tuple_unpack_1__element_2.assign1( UNPACK_NEXT( tmp_tuple_unpack_1__source_iter.asObject0(), 1 ) );
            UNPACK_ITERATOR_CHECK( tmp_tuple_unpack_1__source_iter.asObject0(), 2 );
            par_b.assign0( tmp_tuple_unpack_1__element_1.asObject0() );
            par_c.assign0( tmp_tuple_unpack_1__element_2.asObject0() );
        }
        catch ( PythonException &_exception )
        {
#if PYTHON_VERSION >= 300
            if ( !_exception.hasTraceback() )
            {
                _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
            }
            else
            {
                _exception.addTraceback( frame_guard.getFrame0() );
            }
#else
            _at_lineno_1 = frame_guard.getLineNumber();
#endif

            _caught_1.save( _exception );

#if PYTHON_VERSION >= 300
            frame_guard.preserveExistingException();

            _exception.toExceptionHandler();
#endif
        }

        // Final block:
        tmp_tuple_unpack_1__source_iter.del( true );
        tmp_tuple_unpack_1__element_1.del( true );
        tmp_tuple_unpack_1__element_2.del( true );
#if PYTHON_VERSION < 300
        if ( _at_lineno_1 != 0 )
        {
           frame_guard.setLineNumber( _at_lineno_1 );
        }
#endif
        _caught_1.rethrow();
        // Final end
        frame_guard.setLineNumber( 184 );
        PythonExceptionKeeper _caught_2;
#if PYTHON_VERSION < 300
        int _at_lineno_2 = 0;
#endif


        try
        {
            // Tried block:
            tmp_tuple_unpack_2__source_iter.assign1( MAKE_ITERATOR( par_a.asObject0() ) );
            tmp_tuple_unpack_2__element_1.assign1( UNPACK_NEXT( tmp_tuple_unpack_2__source_iter.asObject0(), 0 ) );
            tmp_tuple_unpack_2__element_2.assign1( UNPACK_NEXT( tmp_tuple_unpack_2__source_iter.asObject0(), 1 ) );
            tmp_tuple_unpack_2__element_3.assign1( UNPACK_NEXT( tmp_tuple_unpack_2__source_iter.asObject0(), 2 ) );
            tmp_tuple_unpack_2__element_4.assign1( UNPACK_NEXT( tmp_tuple_unpack_2__source_iter.asObject0(), 3 ) );
            tmp_tuple_unpack_2__element_5.assign1( UNPACK_NEXT( tmp_tuple_unpack_2__source_iter.asObject0(), 4 ) );
            UNPACK_ITERATOR_CHECK( tmp_tuple_unpack_2__source_iter.asObject0(), 5 );
            var_x.assign0( tmp_tuple_unpack_2__element_1.asObject0() );
            var_y.assign0( tmp_tuple_unpack_2__element_2.asObject0() );
            var_z.assign0( tmp_tuple_unpack_2__element_3.asObject0() );
            var_u.assign0( tmp_tuple_unpack_2__element_4.asObject0() );
            var_v.assign0( tmp_tuple_unpack_2__element_5.asObject0() );
        }
        catch ( PythonException &_exception )
        {
#if PYTHON_VERSION >= 300
            if ( !_exception.hasTraceback() )
            {
                _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
            }
            else
            {
                _exception.addTraceback( frame_guard.getFrame0() );
            }
#else
            _at_lineno_2 = frame_guard.getLineNumber();
#endif

            _caught_2.save( _exception );

#if PYTHON_VERSION >= 300
            frame_guard.preserveExistingException();

            _exception.toExceptionHandler();
#endif
        }

        // Final block:
        tmp_tuple_unpack_2__source_iter.del( true );
        tmp_tuple_unpack_2__element_1.del( true );
        tmp_tuple_unpack_2__element_2.del( true );
        tmp_tuple_unpack_2__element_3.del( true );
        tmp_tuple_unpack_2__element_4.del( true );
        tmp_tuple_unpack_2__element_5.del( true );
#if PYTHON_VERSION < 300
        if ( _at_lineno_2 != 0 )
        {
           frame_guard.setLineNumber( _at_lineno_2 );
        }
#endif
        _caught_2.rethrow();
        // Final end
        frame_guard.setLineNumber( 185 );
        PythonExceptionKeeper _caught_3;
#if PYTHON_VERSION < 300
        int _at_lineno_3 = 0;
#endif


        try
        {
            // Tried block:
            tmp_tuple_unpack_3__source_iter.assign1( MAKE_ITERATOR( par_a.asObject0() ) );
            tmp_tuple_unpack_3__element_1.assign1( UNPACK_NEXT( tmp_tuple_unpack_3__source_iter.asObject0(), 0 ) );
            tmp_tuple_unpack_3__element_2.assign1( UNPACK_NEXT( tmp_tuple_unpack_3__source_iter.asObject0(), 1 ) );
            tmp_tuple_unpack_3__element_3.assign1( UNPACK_NEXT( tmp_tuple_unpack_3__source_iter.asObject0(), 2 ) );
            tmp_tuple_unpack_3__element_4.assign1( UNPACK_NEXT( tmp_tuple_unpack_3__source_iter.asObject0(), 3 ) );
            tmp_tuple_unpack_3__element_5.assign1( UNPACK_NEXT( tmp_tuple_unpack_3__source_iter.asObject0(), 4 ) );
            UNPACK_ITERATOR_CHECK( tmp_tuple_unpack_3__source_iter.asObject0(), 5 );
            var_ex.assign0( tmp_tuple_unpack_3__element_1.asObject0() );
            var_ey.assign0( tmp_tuple_unpack_3__element_2.asObject0() );
            var_ez.assign0( tmp_tuple_unpack_3__element_3.asObject0() );
            var_eu.assign0( tmp_tuple_unpack_3__element_4.asObject0() );
            var_ev.assign0( tmp_tuple_unpack_3__element_5.asObject0() );
        }
        catch ( PythonException &_exception )
        {
#if PYTHON_VERSION >= 300
            if ( !_exception.hasTraceback() )
            {
                _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
            }
            else
            {
                _exception.addTraceback( frame_guard.getFrame0() );
            }
#else
            _at_lineno_3 = frame_guard.getLineNumber();
#endif

            _caught_3.save( _exception );

#if PYTHON_VERSION >= 300
            frame_guard.preserveExistingException();

            _exception.toExceptionHandler();
#endif
        }

        // Final block:
        tmp_tuple_unpack_3__source_iter.del( true );
        tmp_tuple_unpack_3__element_1.del( true );
        tmp_tuple_unpack_3__element_2.del( true );
        tmp_tuple_unpack_3__element_3.del( true );
        tmp_tuple_unpack_3__element_4.del( true );
        tmp_tuple_unpack_3__element_5.del( true );
#if PYTHON_VERSION < 300
        if ( _at_lineno_3 != 0 )
        {
           frame_guard.setLineNumber( _at_lineno_3 );
        }
#endif
        _caught_3.rethrow();
        // Final end
        frame_guard.setLineNumber( 186 );
        {
            PyObjectTempKeeper1 cmp1;
            if ( ( cmp1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_0, 0 ) ), RICH_COMPARE_BOOL_LT( cmp1.asObject0(), PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_b.asObject0(), const_int_0, 0 ) ).asObject0() ) ) )
            {
                frame_guard.setLineNumber( 187 );
                PythonExceptionKeeper _caught_4;
#if PYTHON_VERSION < 300
                int _at_lineno_4 = 0;
#endif


                try
                {
                    // Tried block:
                    {
                        PyObjectTempKeeper0 make_tuple1;
                        tmp_tuple_unpack_4__source_iter.assign1( MAKE_ITERATOR( PyObjectTemporary( ( make_tuple1.assign( par_c.asObject0() ), MAKE_TUPLE2( make_tuple1.asObject0(), par_b.asObject0() ) ) ).asObject0() ) );
                    }
                    tmp_tuple_unpack_4__element_1.assign1( UNPACK_NEXT( tmp_tuple_unpack_4__source_iter.asObject0(), 0 ) );
                    tmp_tuple_unpack_4__element_2.assign1( UNPACK_NEXT( tmp_tuple_unpack_4__source_iter.asObject0(), 1 ) );
                    UNPACK_ITERATOR_CHECK( tmp_tuple_unpack_4__source_iter.asObject0(), 2 );
                    par_b.assign0( tmp_tuple_unpack_4__element_1.asObject0() );
                    par_c.assign0( tmp_tuple_unpack_4__element_2.asObject0() );
                }
                catch ( PythonException &_exception )
                {
#if PYTHON_VERSION >= 300
                    if ( !_exception.hasTraceback() )
                    {
                        _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
                    }
                    else
                    {
                        _exception.addTraceback( frame_guard.getFrame0() );
                    }
#else
                    _at_lineno_4 = frame_guard.getLineNumber();
#endif

                    _caught_4.save( _exception );

#if PYTHON_VERSION >= 300
                    frame_guard.preserveExistingException();

                    _exception.toExceptionHandler();
#endif
                }

                // Final block:
                tmp_tuple_unpack_4__source_iter.del( true );
                tmp_tuple_unpack_4__element_1.del( true );
                tmp_tuple_unpack_4__element_2.del( true );
#if PYTHON_VERSION < 300
                if ( _at_lineno_4 != 0 )
                {
                   frame_guard.setLineNumber( _at_lineno_4 );
                }
#endif
                _caught_4.rethrow();
                // Final end
            }
        }
        frame_guard.setLineNumber( 188 );
        {
            PyObjectTempKeeper1 op1;
            var_ydist.assign1( TO_FLOAT( PyObjectTemporary( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( par_b.asObject0(), const_int_pos_1, 1 ) ), BINARY_OPERATION_SUB( op1.asObject0(), var_y.asObject0() ) ) ).asObject0() ) );
        }
        frame_guard.setLineNumber( 189 );
        {
            PyObjectTempKeeper1 op1;
            PyObjectTempKeeper1 op2;
            var_dx1.assign1( ( op2.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( par_b.asObject0(), const_int_0, 0 ) ), BINARY_OPERATION_SUB( op1.asObject0(), var_x.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_ydist.asObject0() ) ) );
        }
        frame_guard.setLineNumber( 190 );
        {
            PyObjectTempKeeper1 op1;
            PyObjectTempKeeper1 op2;
            var_dx2.assign1( ( op2.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_0, 0 ) ), BINARY_OPERATION_SUB( op1.asObject0(), var_ex.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_ydist.asObject0() ) ) );
        }
        var_dy1.assign0( const_int_pos_1 );
        var_dy2.assign0( const_int_pos_1 );
        frame_guard.setLineNumber( 193 );
        {
            PyObjectTempKeeper1 op1;
            PyObjectTempKeeper1 op2;
            var_dz1.assign1( ( op2.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( par_b.asObject0(), const_int_pos_2, 2 ) ), BINARY_OPERATION_SUB( op1.asObject0(), var_z.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_ydist.asObject0() ) ) );
        }
        frame_guard.setLineNumber( 194 );
        {
            PyObjectTempKeeper1 op1;
            PyObjectTempKeeper1 op2;
            var_dz2.assign1( ( op2.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_2, 2 ) ), BINARY_OPERATION_SUB( op1.asObject0(), var_ez.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_ydist.asObject0() ) ) );
        }
        frame_guard.setLineNumber( 195 );
        {
            PyObjectTempKeeper1 op1;
            PyObjectTempKeeper1 op2;
            var_du1.assign1( ( op2.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( par_b.asObject0(), const_int_pos_3, 3 ) ), BINARY_OPERATION_SUB( op1.asObject0(), var_u.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_ydist.asObject0() ) ) );
        }
        frame_guard.setLineNumber( 196 );
        {
            PyObjectTempKeeper1 op1;
            PyObjectTempKeeper1 op2;
            var_du2.assign1( ( op2.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_3, 3 ) ), BINARY_OPERATION_SUB( op1.asObject0(), var_eu.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_ydist.asObject0() ) ) );
        }
        frame_guard.setLineNumber( 197 );
        {
            PyObjectTempKeeper1 op1;
            PyObjectTempKeeper1 op2;
            var_dv1.assign1( ( op2.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( par_b.asObject0(), const_int_pos_4, 4 ) ), BINARY_OPERATION_SUB( op1.asObject0(), var_v.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_ydist.asObject0() ) ) );
        }
        frame_guard.setLineNumber( 198 );
        {
            PyObjectTempKeeper1 op1;
            PyObjectTempKeeper1 op2;
            var_dv2.assign1( ( op2.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_4, 4 ) ), BINARY_OPERATION_SUB( op1.asObject0(), var_ev.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_ydist.asObject0() ) ) );
        }
        while( true )
        {
            frame_guard.setLineNumber( 199 );
            {
                PyObjectTempKeeper0 cmp1;
                if ( (!( ( cmp1.assign( var_y.asObject0() ), RICH_COMPARE_BOOL_LE( cmp1.asObject0(), PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_b.asObject0(), const_int_pos_1, 1 ) ).asObject0() ) ) )) )
                {
                    break;
                }
            }
            frame_guard.setLineNumber( 200 );
            {
                PyObjectTempKeeper0 call1;
                PyObjectTempKeeper0 call10;
                PyObjectTempKeeper0 call11;
                PyObjectTempKeeper0 call2;
                PyObjectTempKeeper0 call3;
                PyObjectTempKeeper0 call4;
                PyObjectTempKeeper0 call5;
                PyObjectTempKeeper0 call6;
                PyObjectTempKeeper0 call7;
                PyObjectTempKeeper0 call8;
                PyObjectTempKeeper0 call9;
                DECREASE_REFCOUNT( ( call1.assign( GET_MODULE_VALUE0( const_str_plain_draw_line ) ), call2.assign( var_x.asObject0() ), call3.assign( var_y.asObject0() ), call4.assign( var_z.asObject0() ), call5.assign( var_u.asObject0() ), call6.assign( var_v.asObject0() ), call7.assign( var_ex.asObject0() ), call8.assign( var_ey.asObject0() ), call9.assign( var_ez.asObject0() ), call10.assign( var_eu.asObject0() ), call11.assign( var_ev.asObject0() ), CALL_FUNCTION_WITH_ARGS11( call1.asObject0(), call2.asObject0(), call3.asObject0(), call4.asObject0(), call5.asObject0(), call6.asObject0(), call7.asObject0(), call8.asObject0(), call9.asObject0(), call10.asObject0(), call11.asObject0(), par_texture.asObject0() ) ) );
            }
            frame_guard.setLineNumber( 201 );
            PyObject *tmp_inplace_assign_1__inplace_start = var_x.asObject0();
            PyObject *_tmp_inplace_assign_1__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_1__inplace_end = ( op1.assign( tmp_inplace_assign_1__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_dx1.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_1__inplace_end( _tmp_inplace_assign_1__inplace_end );
            if ( ( tmp_inplace_assign_1__inplace_start != tmp_inplace_assign_1__inplace_end.asObject0() ) )
            {
                var_x.assign0( tmp_inplace_assign_1__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 202 );
            PyObject *tmp_inplace_assign_2__inplace_start = var_y.asObject0();
            PyObject *_tmp_inplace_assign_2__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_2__inplace_end = ( op1.assign( tmp_inplace_assign_2__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_dy1.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_2__inplace_end( _tmp_inplace_assign_2__inplace_end );
            if ( ( tmp_inplace_assign_2__inplace_start != tmp_inplace_assign_2__inplace_end.asObject0() ) )
            {
                var_y.assign0( tmp_inplace_assign_2__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 203 );
            PyObject *tmp_inplace_assign_3__inplace_start = var_z.asObject0();
            PyObject *_tmp_inplace_assign_3__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_3__inplace_end = ( op1.assign( tmp_inplace_assign_3__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_dz1.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_3__inplace_end( _tmp_inplace_assign_3__inplace_end );
            if ( ( tmp_inplace_assign_3__inplace_start != tmp_inplace_assign_3__inplace_end.asObject0() ) )
            {
                var_z.assign0( tmp_inplace_assign_3__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 204 );
            PyObject *tmp_inplace_assign_4__inplace_start = var_u.asObject0();
            PyObject *_tmp_inplace_assign_4__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_4__inplace_end = ( op1.assign( tmp_inplace_assign_4__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_du1.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_4__inplace_end( _tmp_inplace_assign_4__inplace_end );
            if ( ( tmp_inplace_assign_4__inplace_start != tmp_inplace_assign_4__inplace_end.asObject0() ) )
            {
                var_u.assign0( tmp_inplace_assign_4__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 205 );
            PyObject *tmp_inplace_assign_5__inplace_start = var_v.asObject0();
            PyObject *_tmp_inplace_assign_5__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_5__inplace_end = ( op1.assign( tmp_inplace_assign_5__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_dv1.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_5__inplace_end( _tmp_inplace_assign_5__inplace_end );
            if ( ( tmp_inplace_assign_5__inplace_start != tmp_inplace_assign_5__inplace_end.asObject0() ) )
            {
                var_v.assign0( tmp_inplace_assign_5__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 206 );
            PyObject *tmp_inplace_assign_6__inplace_start = var_ex.asObject0();
            PyObject *_tmp_inplace_assign_6__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_6__inplace_end = ( op1.assign( tmp_inplace_assign_6__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_dx2.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_6__inplace_end( _tmp_inplace_assign_6__inplace_end );
            if ( ( tmp_inplace_assign_6__inplace_start != tmp_inplace_assign_6__inplace_end.asObject0() ) )
            {
                var_ex.assign0( tmp_inplace_assign_6__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 207 );
            PyObject *tmp_inplace_assign_7__inplace_start = var_ey.asObject0();
            PyObject *_tmp_inplace_assign_7__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_7__inplace_end = ( op1.assign( tmp_inplace_assign_7__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_dy2.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_7__inplace_end( _tmp_inplace_assign_7__inplace_end );
            if ( ( tmp_inplace_assign_7__inplace_start != tmp_inplace_assign_7__inplace_end.asObject0() ) )
            {
                var_ey.assign0( tmp_inplace_assign_7__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 208 );
            PyObject *tmp_inplace_assign_8__inplace_start = var_ez.asObject0();
            PyObject *_tmp_inplace_assign_8__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_8__inplace_end = ( op1.assign( tmp_inplace_assign_8__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_dz2.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_8__inplace_end( _tmp_inplace_assign_8__inplace_end );
            if ( ( tmp_inplace_assign_8__inplace_start != tmp_inplace_assign_8__inplace_end.asObject0() ) )
            {
                var_ez.assign0( tmp_inplace_assign_8__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 209 );
            PyObject *tmp_inplace_assign_9__inplace_start = var_eu.asObject0();
            PyObject *_tmp_inplace_assign_9__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_9__inplace_end = ( op1.assign( tmp_inplace_assign_9__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_du2.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_9__inplace_end( _tmp_inplace_assign_9__inplace_end );
            if ( ( tmp_inplace_assign_9__inplace_start != tmp_inplace_assign_9__inplace_end.asObject0() ) )
            {
                var_eu.assign0( tmp_inplace_assign_9__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 210 );
            PyObject *tmp_inplace_assign_10__inplace_start = var_ev.asObject0();
            PyObject *_tmp_inplace_assign_10__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_10__inplace_end = ( op1.assign( tmp_inplace_assign_10__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_dv2.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_10__inplace_end( _tmp_inplace_assign_10__inplace_end );
            if ( ( tmp_inplace_assign_10__inplace_start != tmp_inplace_assign_10__inplace_end.asObject0() ) )
            {
                var_ev.assign0( tmp_inplace_assign_10__inplace_end.asObject0() );
            }

            CONSIDER_THREADING();
        }
    }
    catch ( PythonException &_exception )
    {
        if ( !_exception.hasTraceback() )
        {
            _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
        }
        else
        {
            _exception.addTraceback( frame_guard.getFrame0() );
        }

        Py_XDECREF( frame_guard.getFrame0()->f_locals );
        frame_guard.getFrame0()->f_locals = par_texture.updateLocalsDict( par_c.updateLocalsDict( par_b.updateLocalsDict( par_a.updateLocalsDict( var_dv2.updateLocalsDict( var_dv1.updateLocalsDict( var_du2.updateLocalsDict( var_du1.updateLocalsDict( var_dz2.updateLocalsDict( var_dz1.updateLocalsDict( var_dy2.updateLocalsDict( var_dy1.updateLocalsDict( var_dx2.updateLocalsDict( var_dx1.updateLocalsDict( var_ydist.updateLocalsDict( var_ev.updateLocalsDict( var_eu.updateLocalsDict( var_ez.updateLocalsDict( var_ey.updateLocalsDict( var_ex.updateLocalsDict( var_v.updateLocalsDict( var_u.updateLocalsDict( var_z.updateLocalsDict( var_y.updateLocalsDict( var_x.updateLocalsDict( PyDict_New() ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) );

        if ( frame_guard.getFrame0() == frame_function_11_draw_tri_point_up_of_module___main__ )
        {
           Py_DECREF( frame_function_11_draw_tri_point_up_of_module___main__ );
           frame_function_11_draw_tri_point_up_of_module___main__ = NULL;
        }

        _exception.toPython();
        return NULL;
    }
    return INCREASE_REFCOUNT( Py_None );
}
static PyObject *fparse_function_11_draw_tri_point_up_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, Py_ssize_t args_size, PyObject *kw )
{
    assert( kw == NULL || PyDict_Check( kw ) );

    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_size = kw ? PyDict_Size( kw ) : 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_found = 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_only_found = 0;
    Py_ssize_t args_given = args_size;
    PyObject *_python_par_a = NULL;
    PyObject *_python_par_b = NULL;
    PyObject *_python_par_c = NULL;
    PyObject *_python_par_texture = NULL;
    // Copy given dictionary values to the the respective variables:
    if ( kw_size > 0 )
    {
        Py_ssize_t ppos = 0;
        PyObject *key, *value;

        while( PyDict_Next( kw, &ppos, &key, &value ) )
        {
#if PYTHON_VERSION < 300
            if (unlikely( !PyString_Check( key ) && !PyUnicode_Check( key ) ))
#else
            if (unlikely( !PyUnicode_Check( key ) ))
#endif
            {
                PyErr_Format( PyExc_TypeError, "draw_tri_point_up() keywords must be strings" );
                goto error_exit;
            }

            NUITKA_MAY_BE_UNUSED bool found = false;

            Py_INCREF( key );
            Py_INCREF( value );

            // Quick path, could be our value.
            if ( found == false && const_str_plain_a == key )
            {
                assert( _python_par_a == NULL );
                _python_par_a = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_b == key )
            {
                assert( _python_par_b == NULL );
                _python_par_b = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_c == key )
            {
                assert( _python_par_c == NULL );
                _python_par_c = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_texture == key )
            {
                assert( _python_par_texture == NULL );
                _python_par_texture = value;

                found = true;
                kw_found += 1;
            }

            // Slow path, compare against all parameter names.
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_a, key ) )
            {
                assert( _python_par_a == NULL );
                _python_par_a = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_b, key ) )
            {
                assert( _python_par_b == NULL );
                _python_par_b = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_c, key ) )
            {
                assert( _python_par_c == NULL );
                _python_par_c = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_texture, key ) )
            {
                assert( _python_par_texture == NULL );
                _python_par_texture = value;

                found = true;
                kw_found += 1;
            }


            Py_DECREF( key );

            if ( found == false )
            {
               Py_DECREF( value );

               PyErr_Format(
                   PyExc_TypeError,
                   "draw_tri_point_up() got an unexpected keyword argument '%s'",
                   Nuitka_String_Check( key ) ? Nuitka_String_AsString( key ) : "<non-string>"
               );

               goto error_exit;
            }
        }

#if PYTHON_VERSION < 300
        assert( kw_found == kw_size );
        assert( kw_only_found == 0 );
#endif
    }

    // Check if too many arguments were given in case of non star args
    if (unlikely( args_given > 4 ))
    {
#if PYTHON_VERSION < 270
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_size );
#elif PYTHON_VERSION < 330
        ERROR_TOO_MANY_ARGUMENTS( self, args_given + kw_found );
#else
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_only_found );
#endif
        goto error_exit;
    }


    // Copy normal parameter values given as part of the args list to the respective variables:

    if (likely( 0 < args_given ))
    {
         if (unlikely( _python_par_a != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 0 );
             goto error_exit;
         }

        _python_par_a = INCREASE_REFCOUNT( args[ 0 ] );
    }
    else if ( _python_par_a == NULL )
    {
        if ( 0 + self->m_defaults_given >= 4  )
        {
            _python_par_a = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 0 - 4 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 1 < args_given ))
    {
         if (unlikely( _python_par_b != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 1 );
             goto error_exit;
         }

        _python_par_b = INCREASE_REFCOUNT( args[ 1 ] );
    }
    else if ( _python_par_b == NULL )
    {
        if ( 1 + self->m_defaults_given >= 4  )
        {
            _python_par_b = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 1 - 4 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 2 < args_given ))
    {
         if (unlikely( _python_par_c != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 2 );
             goto error_exit;
         }

        _python_par_c = INCREASE_REFCOUNT( args[ 2 ] );
    }
    else if ( _python_par_c == NULL )
    {
        if ( 2 + self->m_defaults_given >= 4  )
        {
            _python_par_c = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 2 - 4 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 3 < args_given ))
    {
         if (unlikely( _python_par_texture != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 3 );
             goto error_exit;
         }

        _python_par_texture = INCREASE_REFCOUNT( args[ 3 ] );
    }
    else if ( _python_par_texture == NULL )
    {
        if ( 3 + self->m_defaults_given >= 4  )
        {
            _python_par_texture = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 3 - 4 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }

#if PYTHON_VERSION >= 330
    if (unlikely( _python_par_a == NULL || _python_par_b == NULL || _python_par_c == NULL || _python_par_texture == NULL ))
    {
        PyObject *values[] = { _python_par_a, _python_par_b, _python_par_c, _python_par_texture };
        ERROR_TOO_FEW_ARGUMENTS( self, values );

        goto error_exit;
    }
#endif


    return impl_function_11_draw_tri_point_up_of_module___main__( self, _python_par_a, _python_par_b, _python_par_c, _python_par_texture );

error_exit:;

    Py_XDECREF( _python_par_a );
    Py_XDECREF( _python_par_b );
    Py_XDECREF( _python_par_c );
    Py_XDECREF( _python_par_texture );

    return NULL;
}

static PyObject *dparse_function_11_draw_tri_point_up_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, int size )
{
    if ( size == 4 )
    {
        return impl_function_11_draw_tri_point_up_of_module___main__( self, INCREASE_REFCOUNT( args[ 0 ] ), INCREASE_REFCOUNT( args[ 1 ] ), INCREASE_REFCOUNT( args[ 2 ] ), INCREASE_REFCOUNT( args[ 3 ] ) );
    }
    else
    {
        PyObject *result = fparse_function_11_draw_tri_point_up_of_module___main__( self, args, size, NULL );
        return result;
    }

}



static PyObject *impl_lambda_1_lambda_of_function_11_draw_tri_point_up_of_module___main__( Nuitka_FunctionObject *self, PyObject *_python_par_t )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par_t( const_str_plain_t, _python_par_t );

    // Actual function code.
    static PyFrameObject *frame_lambda_1_lambda_of_function_11_draw_tri_point_up_of_module___main__ = NULL;

    if ( isFrameUnusable( frame_lambda_1_lambda_of_function_11_draw_tri_point_up_of_module___main__ ) )
    {
        if ( frame_lambda_1_lambda_of_function_11_draw_tri_point_up_of_module___main__ )
        {
#if _DEBUG_REFRAME
            puts( "reframe for lambda_1_lambda_of_function_11_draw_tri_point_up_of_module___main__" );
#endif
            Py_DECREF( frame_lambda_1_lambda_of_function_11_draw_tri_point_up_of_module___main__ );
        }

        frame_lambda_1_lambda_of_function_11_draw_tri_point_up_of_module___main__ = MAKE_FRAME( codeobj_a7ab5a3207021c9d3e33271791acc28a, module___main__ );
    }

    FrameGuard frame_guard( frame_lambda_1_lambda_of_function_11_draw_tri_point_up_of_module___main__ );
    try
    {
        assert( Py_REFCNT( frame_lambda_1_lambda_of_function_11_draw_tri_point_up_of_module___main__ ) == 2 ); // Frame stack
        frame_guard.setLineNumber( 183 );
        return LOOKUP_SUBSCRIPT_CONST( par_t.asObject0(), const_int_0, 0 );
    }
    catch ( PythonException &_exception )
    {
        if ( !_exception.hasTraceback() )
        {
            _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
        }
        else
        {
            _exception.addTraceback( frame_guard.getFrame0() );
        }

        Py_XDECREF( frame_guard.getFrame0()->f_locals );
        frame_guard.getFrame0()->f_locals = par_t.updateLocalsDict( PyDict_New() );

        if ( frame_guard.getFrame0() == frame_lambda_1_lambda_of_function_11_draw_tri_point_up_of_module___main__ )
        {
           Py_DECREF( frame_lambda_1_lambda_of_function_11_draw_tri_point_up_of_module___main__ );
           frame_lambda_1_lambda_of_function_11_draw_tri_point_up_of_module___main__ = NULL;
        }

        _exception.toPython();
        return NULL;
    }

}
static PyObject *fparse_lambda_1_lambda_of_function_11_draw_tri_point_up_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, Py_ssize_t args_size, PyObject *kw )
{
    assert( kw == NULL || PyDict_Check( kw ) );

    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_size = kw ? PyDict_Size( kw ) : 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_found = 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_only_found = 0;
    Py_ssize_t args_given = args_size;
    PyObject *_python_par_t = NULL;
    // Copy given dictionary values to the the respective variables:
    if ( kw_size > 0 )
    {
        Py_ssize_t ppos = 0;
        PyObject *key, *value;

        while( PyDict_Next( kw, &ppos, &key, &value ) )
        {
#if PYTHON_VERSION < 300
            if (unlikely( !PyString_Check( key ) && !PyUnicode_Check( key ) ))
#else
            if (unlikely( !PyUnicode_Check( key ) ))
#endif
            {
                PyErr_Format( PyExc_TypeError, "<lambda>() keywords must be strings" );
                goto error_exit;
            }

            NUITKA_MAY_BE_UNUSED bool found = false;

            Py_INCREF( key );
            Py_INCREF( value );

            // Quick path, could be our value.
            if ( found == false && const_str_plain_t == key )
            {
                assert( _python_par_t == NULL );
                _python_par_t = value;

                found = true;
                kw_found += 1;
            }

            // Slow path, compare against all parameter names.
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_t, key ) )
            {
                assert( _python_par_t == NULL );
                _python_par_t = value;

                found = true;
                kw_found += 1;
            }


            Py_DECREF( key );

            if ( found == false )
            {
               Py_DECREF( value );

               PyErr_Format(
                   PyExc_TypeError,
                   "<lambda>() got an unexpected keyword argument '%s'",
                   Nuitka_String_Check( key ) ? Nuitka_String_AsString( key ) : "<non-string>"
               );

               goto error_exit;
            }
        }

#if PYTHON_VERSION < 300
        assert( kw_found == kw_size );
        assert( kw_only_found == 0 );
#endif
    }

    // Check if too many arguments were given in case of non star args
    if (unlikely( args_given > 1 ))
    {
#if PYTHON_VERSION < 270
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_size );
#elif PYTHON_VERSION < 330
        ERROR_TOO_MANY_ARGUMENTS( self, args_given + kw_found );
#else
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_only_found );
#endif
        goto error_exit;
    }


    // Copy normal parameter values given as part of the args list to the respective variables:

    if (likely( 0 < args_given ))
    {
         if (unlikely( _python_par_t != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 0 );
             goto error_exit;
         }

        _python_par_t = INCREASE_REFCOUNT( args[ 0 ] );
    }
    else if ( _python_par_t == NULL )
    {
        if ( 0 + self->m_defaults_given >= 1  )
        {
            _python_par_t = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 0 - 1 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }

#if PYTHON_VERSION >= 330
    if (unlikely( _python_par_t == NULL ))
    {
        PyObject *values[] = { _python_par_t };
        ERROR_TOO_FEW_ARGUMENTS( self, values );

        goto error_exit;
    }
#endif


    return impl_lambda_1_lambda_of_function_11_draw_tri_point_up_of_module___main__( self, _python_par_t );

error_exit:;

    Py_XDECREF( _python_par_t );

    return NULL;
}

static PyObject *dparse_lambda_1_lambda_of_function_11_draw_tri_point_up_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, int size )
{
    if ( size == 1 )
    {
        return impl_lambda_1_lambda_of_function_11_draw_tri_point_up_of_module___main__( self, INCREASE_REFCOUNT( args[ 0 ] ) );
    }
    else
    {
        PyObject *result = fparse_lambda_1_lambda_of_function_11_draw_tri_point_up_of_module___main__( self, args, size, NULL );
        return result;
    }

}



static PyObject *impl_function_12_draw_tri_point_down_of_module___main__( Nuitka_FunctionObject *self, PyObject *_python_par_a, PyObject *_python_par_b, PyObject *_python_par_c, PyObject *_python_par_texture )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par_a( const_str_plain_a, _python_par_a );
    PyObjectLocalParameterVariableNoDel par_b( const_str_plain_b, _python_par_b );
    PyObjectLocalParameterVariableNoDel par_c( const_str_plain_c, _python_par_c );
    PyObjectLocalParameterVariableNoDel par_texture( const_str_plain_texture, _python_par_texture );
    PyObjectLocalVariable var_x( const_str_plain_x );
    PyObjectLocalVariable var_y( const_str_plain_y );
    PyObjectLocalVariable var_z( const_str_plain_z );
    PyObjectLocalVariable var_u( const_str_plain_u );
    PyObjectLocalVariable var_v( const_str_plain_v );
    PyObjectLocalVariable var_ex( const_str_plain_ex );
    PyObjectLocalVariable var_ey( const_str_plain_ey );
    PyObjectLocalVariable var_ez( const_str_plain_ez );
    PyObjectLocalVariable var_eu( const_str_plain_eu );
    PyObjectLocalVariable var_ev( const_str_plain_ev );
    PyObjectLocalVariable var_ydist( const_str_plain_ydist );
    PyObjectLocalVariable var_dx1( const_str_plain_dx1 );
    PyObjectLocalVariable var_dx2( const_str_plain_dx2 );
    PyObjectLocalVariable var_dy1( const_str_plain_dy1 );
    PyObjectLocalVariable var_dy2( const_str_plain_dy2 );
    PyObjectLocalVariable var_dz1( const_str_plain_dz1 );
    PyObjectLocalVariable var_dz2( const_str_plain_dz2 );
    PyObjectLocalVariable var_du1( const_str_plain_du1 );
    PyObjectLocalVariable var_du2( const_str_plain_du2 );
    PyObjectLocalVariable var_dv1( const_str_plain_dv1 );
    PyObjectLocalVariable var_dv2( const_str_plain_dv2 );
    PyObjectTempVariable tmp_tuple_unpack_1__source_iter;
    PyObjectTempVariable tmp_tuple_unpack_1__element_1;
    PyObjectTempVariable tmp_tuple_unpack_1__element_2;
    PyObjectTempVariable tmp_tuple_unpack_2__source_iter;
    PyObjectTempVariable tmp_tuple_unpack_2__element_1;
    PyObjectTempVariable tmp_tuple_unpack_2__element_2;
    PyObjectTempVariable tmp_tuple_unpack_2__element_3;
    PyObjectTempVariable tmp_tuple_unpack_2__element_4;
    PyObjectTempVariable tmp_tuple_unpack_2__element_5;
    PyObjectTempVariable tmp_tuple_unpack_3__source_iter;
    PyObjectTempVariable tmp_tuple_unpack_3__element_1;
    PyObjectTempVariable tmp_tuple_unpack_3__element_2;
    PyObjectTempVariable tmp_tuple_unpack_3__element_3;
    PyObjectTempVariable tmp_tuple_unpack_3__element_4;
    PyObjectTempVariable tmp_tuple_unpack_3__element_5;

    // Actual function code.
    static PyFrameObject *frame_function_12_draw_tri_point_down_of_module___main__ = NULL;

    if ( isFrameUnusable( frame_function_12_draw_tri_point_down_of_module___main__ ) )
    {
        if ( frame_function_12_draw_tri_point_down_of_module___main__ )
        {
#if _DEBUG_REFRAME
            puts( "reframe for function_12_draw_tri_point_down_of_module___main__" );
#endif
            Py_DECREF( frame_function_12_draw_tri_point_down_of_module___main__ );
        }

        frame_function_12_draw_tri_point_down_of_module___main__ = MAKE_FRAME( codeobj_de70289dd64a188bbb72feae2ef939c4, module___main__ );
    }

    FrameGuard frame_guard( frame_function_12_draw_tri_point_down_of_module___main__ );
    try
    {
        assert( Py_REFCNT( frame_function_12_draw_tri_point_down_of_module___main__ ) == 2 ); // Frame stack
        frame_guard.setLineNumber( 214 );
        {
            PyObjectTempKeeper1 cmp1;
            if ( ( cmp1.assign( LOOKUP_SUBSCRIPT_CONST( par_b.asObject0(), const_int_0, 0 ) ), RICH_COMPARE_BOOL_LT( cmp1.asObject0(), PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_a.asObject0(), const_int_0, 0 ) ).asObject0() ) ) )
            {
                frame_guard.setLineNumber( 215 );
                PythonExceptionKeeper _caught_1;
#if PYTHON_VERSION < 300
                int _at_lineno_1 = 0;
#endif


                try
                {
                    // Tried block:
                    {
                        PyObjectTempKeeper0 make_tuple1;
                        tmp_tuple_unpack_1__source_iter.assign1( MAKE_ITERATOR( PyObjectTemporary( ( make_tuple1.assign( par_a.asObject0() ), MAKE_TUPLE2( make_tuple1.asObject0(), par_b.asObject0() ) ) ).asObject0() ) );
                    }
                    tmp_tuple_unpack_1__element_1.assign1( UNPACK_NEXT( tmp_tuple_unpack_1__source_iter.asObject0(), 0 ) );
                    tmp_tuple_unpack_1__element_2.assign1( UNPACK_NEXT( tmp_tuple_unpack_1__source_iter.asObject0(), 1 ) );
                    UNPACK_ITERATOR_CHECK( tmp_tuple_unpack_1__source_iter.asObject0(), 2 );
                    par_b.assign0( tmp_tuple_unpack_1__element_1.asObject0() );
                    par_a.assign0( tmp_tuple_unpack_1__element_2.asObject0() );
                }
                catch ( PythonException &_exception )
                {
#if PYTHON_VERSION >= 300
                    if ( !_exception.hasTraceback() )
                    {
                        _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
                    }
                    else
                    {
                        _exception.addTraceback( frame_guard.getFrame0() );
                    }
#else
                    _at_lineno_1 = frame_guard.getLineNumber();
#endif

                    _caught_1.save( _exception );

#if PYTHON_VERSION >= 300
                    frame_guard.preserveExistingException();

                    _exception.toExceptionHandler();
#endif
                }

                // Final block:
                tmp_tuple_unpack_1__source_iter.del( true );
                tmp_tuple_unpack_1__element_1.del( true );
                tmp_tuple_unpack_1__element_2.del( true );
#if PYTHON_VERSION < 300
                if ( _at_lineno_1 != 0 )
                {
                   frame_guard.setLineNumber( _at_lineno_1 );
                }
#endif
                _caught_1.rethrow();
                // Final end
            }
        }
        frame_guard.setLineNumber( 216 );
        PythonExceptionKeeper _caught_2;
#if PYTHON_VERSION < 300
        int _at_lineno_2 = 0;
#endif


        try
        {
            // Tried block:
            tmp_tuple_unpack_2__source_iter.assign1( MAKE_ITERATOR( par_a.asObject0() ) );
            tmp_tuple_unpack_2__element_1.assign1( UNPACK_NEXT( tmp_tuple_unpack_2__source_iter.asObject0(), 0 ) );
            tmp_tuple_unpack_2__element_2.assign1( UNPACK_NEXT( tmp_tuple_unpack_2__source_iter.asObject0(), 1 ) );
            tmp_tuple_unpack_2__element_3.assign1( UNPACK_NEXT( tmp_tuple_unpack_2__source_iter.asObject0(), 2 ) );
            tmp_tuple_unpack_2__element_4.assign1( UNPACK_NEXT( tmp_tuple_unpack_2__source_iter.asObject0(), 3 ) );
            tmp_tuple_unpack_2__element_5.assign1( UNPACK_NEXT( tmp_tuple_unpack_2__source_iter.asObject0(), 4 ) );
            UNPACK_ITERATOR_CHECK( tmp_tuple_unpack_2__source_iter.asObject0(), 5 );
            var_x.assign0( tmp_tuple_unpack_2__element_1.asObject0() );
            var_y.assign0( tmp_tuple_unpack_2__element_2.asObject0() );
            var_z.assign0( tmp_tuple_unpack_2__element_3.asObject0() );
            var_u.assign0( tmp_tuple_unpack_2__element_4.asObject0() );
            var_v.assign0( tmp_tuple_unpack_2__element_5.asObject0() );
        }
        catch ( PythonException &_exception )
        {
#if PYTHON_VERSION >= 300
            if ( !_exception.hasTraceback() )
            {
                _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
            }
            else
            {
                _exception.addTraceback( frame_guard.getFrame0() );
            }
#else
            _at_lineno_2 = frame_guard.getLineNumber();
#endif

            _caught_2.save( _exception );

#if PYTHON_VERSION >= 300
            frame_guard.preserveExistingException();

            _exception.toExceptionHandler();
#endif
        }

        // Final block:
        tmp_tuple_unpack_2__source_iter.del( true );
        tmp_tuple_unpack_2__element_1.del( true );
        tmp_tuple_unpack_2__element_2.del( true );
        tmp_tuple_unpack_2__element_3.del( true );
        tmp_tuple_unpack_2__element_4.del( true );
        tmp_tuple_unpack_2__element_5.del( true );
#if PYTHON_VERSION < 300
        if ( _at_lineno_2 != 0 )
        {
           frame_guard.setLineNumber( _at_lineno_2 );
        }
#endif
        _caught_2.rethrow();
        // Final end
        frame_guard.setLineNumber( 217 );
        PythonExceptionKeeper _caught_3;
#if PYTHON_VERSION < 300
        int _at_lineno_3 = 0;
#endif


        try
        {
            // Tried block:
            tmp_tuple_unpack_3__source_iter.assign1( MAKE_ITERATOR( par_b.asObject0() ) );
            tmp_tuple_unpack_3__element_1.assign1( UNPACK_NEXT( tmp_tuple_unpack_3__source_iter.asObject0(), 0 ) );
            tmp_tuple_unpack_3__element_2.assign1( UNPACK_NEXT( tmp_tuple_unpack_3__source_iter.asObject0(), 1 ) );
            tmp_tuple_unpack_3__element_3.assign1( UNPACK_NEXT( tmp_tuple_unpack_3__source_iter.asObject0(), 2 ) );
            tmp_tuple_unpack_3__element_4.assign1( UNPACK_NEXT( tmp_tuple_unpack_3__source_iter.asObject0(), 3 ) );
            tmp_tuple_unpack_3__element_5.assign1( UNPACK_NEXT( tmp_tuple_unpack_3__source_iter.asObject0(), 4 ) );
            UNPACK_ITERATOR_CHECK( tmp_tuple_unpack_3__source_iter.asObject0(), 5 );
            var_ex.assign0( tmp_tuple_unpack_3__element_1.asObject0() );
            var_ey.assign0( tmp_tuple_unpack_3__element_2.asObject0() );
            var_ez.assign0( tmp_tuple_unpack_3__element_3.asObject0() );
            var_eu.assign0( tmp_tuple_unpack_3__element_4.asObject0() );
            var_ev.assign0( tmp_tuple_unpack_3__element_5.asObject0() );
        }
        catch ( PythonException &_exception )
        {
#if PYTHON_VERSION >= 300
            if ( !_exception.hasTraceback() )
            {
                _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
            }
            else
            {
                _exception.addTraceback( frame_guard.getFrame0() );
            }
#else
            _at_lineno_3 = frame_guard.getLineNumber();
#endif

            _caught_3.save( _exception );

#if PYTHON_VERSION >= 300
            frame_guard.preserveExistingException();

            _exception.toExceptionHandler();
#endif
        }

        // Final block:
        tmp_tuple_unpack_3__source_iter.del( true );
        tmp_tuple_unpack_3__element_1.del( true );
        tmp_tuple_unpack_3__element_2.del( true );
        tmp_tuple_unpack_3__element_3.del( true );
        tmp_tuple_unpack_3__element_4.del( true );
        tmp_tuple_unpack_3__element_5.del( true );
#if PYTHON_VERSION < 300
        if ( _at_lineno_3 != 0 )
        {
           frame_guard.setLineNumber( _at_lineno_3 );
        }
#endif
        _caught_3.rethrow();
        // Final end
        frame_guard.setLineNumber( 218 );
        {
            PyObjectTempKeeper1 op1;
            var_ydist.assign1( TO_FLOAT( PyObjectTemporary( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_1, 1 ) ), BINARY_OPERATION_SUB( op1.asObject0(), var_y.asObject0() ) ) ).asObject0() ) );
        }
        frame_guard.setLineNumber( 219 );
        {
            PyObjectTempKeeper1 op1;
            PyObjectTempKeeper1 op2;
            var_dx1.assign1( ( op2.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_0, 0 ) ), BINARY_OPERATION_SUB( op1.asObject0(), var_x.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_ydist.asObject0() ) ) );
        }
        frame_guard.setLineNumber( 220 );
        {
            PyObjectTempKeeper1 op1;
            PyObjectTempKeeper1 op2;
            var_dx2.assign1( ( op2.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_0, 0 ) ), BINARY_OPERATION_SUB( op1.asObject0(), var_ex.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_ydist.asObject0() ) ) );
        }
        var_dy1.assign0( const_int_pos_1 );
        var_dy2.assign0( const_int_pos_1 );
        frame_guard.setLineNumber( 223 );
        {
            PyObjectTempKeeper1 op1;
            PyObjectTempKeeper1 op2;
            var_dz1.assign1( ( op2.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_2, 2 ) ), BINARY_OPERATION_SUB( op1.asObject0(), var_z.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_ydist.asObject0() ) ) );
        }
        frame_guard.setLineNumber( 224 );
        {
            PyObjectTempKeeper1 op1;
            PyObjectTempKeeper1 op2;
            var_dz2.assign1( ( op2.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_2, 2 ) ), BINARY_OPERATION_SUB( op1.asObject0(), var_ez.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_ydist.asObject0() ) ) );
        }
        frame_guard.setLineNumber( 225 );
        {
            PyObjectTempKeeper1 op1;
            PyObjectTempKeeper1 op2;
            var_du1.assign1( ( op2.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_3, 3 ) ), BINARY_OPERATION_SUB( op1.asObject0(), var_u.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_ydist.asObject0() ) ) );
        }
        frame_guard.setLineNumber( 226 );
        {
            PyObjectTempKeeper1 op1;
            PyObjectTempKeeper1 op2;
            var_du2.assign1( ( op2.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_3, 3 ) ), BINARY_OPERATION_SUB( op1.asObject0(), var_eu.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_ydist.asObject0() ) ) );
        }
        frame_guard.setLineNumber( 227 );
        {
            PyObjectTempKeeper1 op1;
            PyObjectTempKeeper1 op2;
            var_dv1.assign1( ( op2.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_4, 4 ) ), BINARY_OPERATION_SUB( op1.asObject0(), var_v.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_ydist.asObject0() ) ) );
        }
        frame_guard.setLineNumber( 228 );
        {
            PyObjectTempKeeper1 op1;
            PyObjectTempKeeper1 op2;
            var_dv2.assign1( ( op2.assign( ( op1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_4, 4 ) ), BINARY_OPERATION_SUB( op1.asObject0(), var_ev.asObject0() ) ) ), BINARY_OPERATION_DIV( op2.asObject0(), var_ydist.asObject0() ) ) );
        }
        while( true )
        {
            frame_guard.setLineNumber( 229 );
            {
                PyObjectTempKeeper0 cmp1;
                if ( (!( ( cmp1.assign( var_y.asObject0() ), RICH_COMPARE_BOOL_LE( cmp1.asObject0(), PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_1, 1 ) ).asObject0() ) ) )) )
                {
                    break;
                }
            }
            frame_guard.setLineNumber( 230 );
            {
                PyObjectTempKeeper0 call1;
                PyObjectTempKeeper0 call10;
                PyObjectTempKeeper0 call11;
                PyObjectTempKeeper0 call2;
                PyObjectTempKeeper0 call3;
                PyObjectTempKeeper0 call4;
                PyObjectTempKeeper0 call5;
                PyObjectTempKeeper0 call6;
                PyObjectTempKeeper0 call7;
                PyObjectTempKeeper0 call8;
                PyObjectTempKeeper0 call9;
                DECREASE_REFCOUNT( ( call1.assign( GET_MODULE_VALUE0( const_str_plain_draw_line ) ), call2.assign( var_x.asObject0() ), call3.assign( var_y.asObject0() ), call4.assign( var_z.asObject0() ), call5.assign( var_u.asObject0() ), call6.assign( var_v.asObject0() ), call7.assign( var_ex.asObject0() ), call8.assign( var_ey.asObject0() ), call9.assign( var_ez.asObject0() ), call10.assign( var_eu.asObject0() ), call11.assign( var_ev.asObject0() ), CALL_FUNCTION_WITH_ARGS11( call1.asObject0(), call2.asObject0(), call3.asObject0(), call4.asObject0(), call5.asObject0(), call6.asObject0(), call7.asObject0(), call8.asObject0(), call9.asObject0(), call10.asObject0(), call11.asObject0(), par_texture.asObject0() ) ) );
            }
            frame_guard.setLineNumber( 231 );
            PyObject *tmp_inplace_assign_1__inplace_start = var_x.asObject0();
            PyObject *_tmp_inplace_assign_1__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_1__inplace_end = ( op1.assign( tmp_inplace_assign_1__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_dx1.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_1__inplace_end( _tmp_inplace_assign_1__inplace_end );
            if ( ( tmp_inplace_assign_1__inplace_start != tmp_inplace_assign_1__inplace_end.asObject0() ) )
            {
                var_x.assign0( tmp_inplace_assign_1__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 232 );
            PyObject *tmp_inplace_assign_2__inplace_start = var_y.asObject0();
            PyObject *_tmp_inplace_assign_2__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_2__inplace_end = ( op1.assign( tmp_inplace_assign_2__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_dy1.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_2__inplace_end( _tmp_inplace_assign_2__inplace_end );
            if ( ( tmp_inplace_assign_2__inplace_start != tmp_inplace_assign_2__inplace_end.asObject0() ) )
            {
                var_y.assign0( tmp_inplace_assign_2__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 233 );
            PyObject *tmp_inplace_assign_3__inplace_start = var_z.asObject0();
            PyObject *_tmp_inplace_assign_3__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_3__inplace_end = ( op1.assign( tmp_inplace_assign_3__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_dz1.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_3__inplace_end( _tmp_inplace_assign_3__inplace_end );
            if ( ( tmp_inplace_assign_3__inplace_start != tmp_inplace_assign_3__inplace_end.asObject0() ) )
            {
                var_z.assign0( tmp_inplace_assign_3__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 234 );
            PyObject *tmp_inplace_assign_4__inplace_start = var_u.asObject0();
            PyObject *_tmp_inplace_assign_4__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_4__inplace_end = ( op1.assign( tmp_inplace_assign_4__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_du1.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_4__inplace_end( _tmp_inplace_assign_4__inplace_end );
            if ( ( tmp_inplace_assign_4__inplace_start != tmp_inplace_assign_4__inplace_end.asObject0() ) )
            {
                var_u.assign0( tmp_inplace_assign_4__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 235 );
            PyObject *tmp_inplace_assign_5__inplace_start = var_v.asObject0();
            PyObject *_tmp_inplace_assign_5__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_5__inplace_end = ( op1.assign( tmp_inplace_assign_5__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_dv1.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_5__inplace_end( _tmp_inplace_assign_5__inplace_end );
            if ( ( tmp_inplace_assign_5__inplace_start != tmp_inplace_assign_5__inplace_end.asObject0() ) )
            {
                var_v.assign0( tmp_inplace_assign_5__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 236 );
            PyObject *tmp_inplace_assign_6__inplace_start = var_ex.asObject0();
            PyObject *_tmp_inplace_assign_6__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_6__inplace_end = ( op1.assign( tmp_inplace_assign_6__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_dx2.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_6__inplace_end( _tmp_inplace_assign_6__inplace_end );
            if ( ( tmp_inplace_assign_6__inplace_start != tmp_inplace_assign_6__inplace_end.asObject0() ) )
            {
                var_ex.assign0( tmp_inplace_assign_6__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 237 );
            PyObject *tmp_inplace_assign_7__inplace_start = var_ey.asObject0();
            PyObject *_tmp_inplace_assign_7__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_7__inplace_end = ( op1.assign( tmp_inplace_assign_7__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_dy2.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_7__inplace_end( _tmp_inplace_assign_7__inplace_end );
            if ( ( tmp_inplace_assign_7__inplace_start != tmp_inplace_assign_7__inplace_end.asObject0() ) )
            {
                var_ey.assign0( tmp_inplace_assign_7__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 238 );
            PyObject *tmp_inplace_assign_8__inplace_start = var_ez.asObject0();
            PyObject *_tmp_inplace_assign_8__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_8__inplace_end = ( op1.assign( tmp_inplace_assign_8__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_dz2.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_8__inplace_end( _tmp_inplace_assign_8__inplace_end );
            if ( ( tmp_inplace_assign_8__inplace_start != tmp_inplace_assign_8__inplace_end.asObject0() ) )
            {
                var_ez.assign0( tmp_inplace_assign_8__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 239 );
            PyObject *tmp_inplace_assign_9__inplace_start = var_eu.asObject0();
            PyObject *_tmp_inplace_assign_9__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_9__inplace_end = ( op1.assign( tmp_inplace_assign_9__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_du2.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_9__inplace_end( _tmp_inplace_assign_9__inplace_end );
            if ( ( tmp_inplace_assign_9__inplace_start != tmp_inplace_assign_9__inplace_end.asObject0() ) )
            {
                var_eu.assign0( tmp_inplace_assign_9__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 240 );
            PyObject *tmp_inplace_assign_10__inplace_start = var_ev.asObject0();
            PyObject *_tmp_inplace_assign_10__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_10__inplace_end = ( op1.assign( tmp_inplace_assign_10__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceAdd, op1.asObject0(), var_dv2.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_10__inplace_end( _tmp_inplace_assign_10__inplace_end );
            if ( ( tmp_inplace_assign_10__inplace_start != tmp_inplace_assign_10__inplace_end.asObject0() ) )
            {
                var_ev.assign0( tmp_inplace_assign_10__inplace_end.asObject0() );
            }

            CONSIDER_THREADING();
        }
    }
    catch ( PythonException &_exception )
    {
        if ( !_exception.hasTraceback() )
        {
            _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
        }
        else
        {
            _exception.addTraceback( frame_guard.getFrame0() );
        }

        Py_XDECREF( frame_guard.getFrame0()->f_locals );
        frame_guard.getFrame0()->f_locals = par_texture.updateLocalsDict( par_c.updateLocalsDict( par_b.updateLocalsDict( par_a.updateLocalsDict( var_dv2.updateLocalsDict( var_dv1.updateLocalsDict( var_du2.updateLocalsDict( var_du1.updateLocalsDict( var_dz2.updateLocalsDict( var_dz1.updateLocalsDict( var_dy2.updateLocalsDict( var_dy1.updateLocalsDict( var_dx2.updateLocalsDict( var_dx1.updateLocalsDict( var_ydist.updateLocalsDict( var_ev.updateLocalsDict( var_eu.updateLocalsDict( var_ez.updateLocalsDict( var_ey.updateLocalsDict( var_ex.updateLocalsDict( var_v.updateLocalsDict( var_u.updateLocalsDict( var_z.updateLocalsDict( var_y.updateLocalsDict( var_x.updateLocalsDict( PyDict_New() ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) );

        if ( frame_guard.getFrame0() == frame_function_12_draw_tri_point_down_of_module___main__ )
        {
           Py_DECREF( frame_function_12_draw_tri_point_down_of_module___main__ );
           frame_function_12_draw_tri_point_down_of_module___main__ = NULL;
        }

        _exception.toPython();
        return NULL;
    }
    return INCREASE_REFCOUNT( Py_None );
}
static PyObject *fparse_function_12_draw_tri_point_down_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, Py_ssize_t args_size, PyObject *kw )
{
    assert( kw == NULL || PyDict_Check( kw ) );

    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_size = kw ? PyDict_Size( kw ) : 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_found = 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_only_found = 0;
    Py_ssize_t args_given = args_size;
    PyObject *_python_par_a = NULL;
    PyObject *_python_par_b = NULL;
    PyObject *_python_par_c = NULL;
    PyObject *_python_par_texture = NULL;
    // Copy given dictionary values to the the respective variables:
    if ( kw_size > 0 )
    {
        Py_ssize_t ppos = 0;
        PyObject *key, *value;

        while( PyDict_Next( kw, &ppos, &key, &value ) )
        {
#if PYTHON_VERSION < 300
            if (unlikely( !PyString_Check( key ) && !PyUnicode_Check( key ) ))
#else
            if (unlikely( !PyUnicode_Check( key ) ))
#endif
            {
                PyErr_Format( PyExc_TypeError, "draw_tri_point_down() keywords must be strings" );
                goto error_exit;
            }

            NUITKA_MAY_BE_UNUSED bool found = false;

            Py_INCREF( key );
            Py_INCREF( value );

            // Quick path, could be our value.
            if ( found == false && const_str_plain_a == key )
            {
                assert( _python_par_a == NULL );
                _python_par_a = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_b == key )
            {
                assert( _python_par_b == NULL );
                _python_par_b = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_c == key )
            {
                assert( _python_par_c == NULL );
                _python_par_c = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_texture == key )
            {
                assert( _python_par_texture == NULL );
                _python_par_texture = value;

                found = true;
                kw_found += 1;
            }

            // Slow path, compare against all parameter names.
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_a, key ) )
            {
                assert( _python_par_a == NULL );
                _python_par_a = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_b, key ) )
            {
                assert( _python_par_b == NULL );
                _python_par_b = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_c, key ) )
            {
                assert( _python_par_c == NULL );
                _python_par_c = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_texture, key ) )
            {
                assert( _python_par_texture == NULL );
                _python_par_texture = value;

                found = true;
                kw_found += 1;
            }


            Py_DECREF( key );

            if ( found == false )
            {
               Py_DECREF( value );

               PyErr_Format(
                   PyExc_TypeError,
                   "draw_tri_point_down() got an unexpected keyword argument '%s'",
                   Nuitka_String_Check( key ) ? Nuitka_String_AsString( key ) : "<non-string>"
               );

               goto error_exit;
            }
        }

#if PYTHON_VERSION < 300
        assert( kw_found == kw_size );
        assert( kw_only_found == 0 );
#endif
    }

    // Check if too many arguments were given in case of non star args
    if (unlikely( args_given > 4 ))
    {
#if PYTHON_VERSION < 270
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_size );
#elif PYTHON_VERSION < 330
        ERROR_TOO_MANY_ARGUMENTS( self, args_given + kw_found );
#else
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_only_found );
#endif
        goto error_exit;
    }


    // Copy normal parameter values given as part of the args list to the respective variables:

    if (likely( 0 < args_given ))
    {
         if (unlikely( _python_par_a != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 0 );
             goto error_exit;
         }

        _python_par_a = INCREASE_REFCOUNT( args[ 0 ] );
    }
    else if ( _python_par_a == NULL )
    {
        if ( 0 + self->m_defaults_given >= 4  )
        {
            _python_par_a = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 0 - 4 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 1 < args_given ))
    {
         if (unlikely( _python_par_b != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 1 );
             goto error_exit;
         }

        _python_par_b = INCREASE_REFCOUNT( args[ 1 ] );
    }
    else if ( _python_par_b == NULL )
    {
        if ( 1 + self->m_defaults_given >= 4  )
        {
            _python_par_b = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 1 - 4 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 2 < args_given ))
    {
         if (unlikely( _python_par_c != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 2 );
             goto error_exit;
         }

        _python_par_c = INCREASE_REFCOUNT( args[ 2 ] );
    }
    else if ( _python_par_c == NULL )
    {
        if ( 2 + self->m_defaults_given >= 4  )
        {
            _python_par_c = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 2 - 4 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 3 < args_given ))
    {
         if (unlikely( _python_par_texture != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 3 );
             goto error_exit;
         }

        _python_par_texture = INCREASE_REFCOUNT( args[ 3 ] );
    }
    else if ( _python_par_texture == NULL )
    {
        if ( 3 + self->m_defaults_given >= 4  )
        {
            _python_par_texture = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 3 - 4 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }

#if PYTHON_VERSION >= 330
    if (unlikely( _python_par_a == NULL || _python_par_b == NULL || _python_par_c == NULL || _python_par_texture == NULL ))
    {
        PyObject *values[] = { _python_par_a, _python_par_b, _python_par_c, _python_par_texture };
        ERROR_TOO_FEW_ARGUMENTS( self, values );

        goto error_exit;
    }
#endif


    return impl_function_12_draw_tri_point_down_of_module___main__( self, _python_par_a, _python_par_b, _python_par_c, _python_par_texture );

error_exit:;

    Py_XDECREF( _python_par_a );
    Py_XDECREF( _python_par_b );
    Py_XDECREF( _python_par_c );
    Py_XDECREF( _python_par_texture );

    return NULL;
}

static PyObject *dparse_function_12_draw_tri_point_down_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, int size )
{
    if ( size == 4 )
    {
        return impl_function_12_draw_tri_point_down_of_module___main__( self, INCREASE_REFCOUNT( args[ 0 ] ), INCREASE_REFCOUNT( args[ 1 ] ), INCREASE_REFCOUNT( args[ 2 ] ), INCREASE_REFCOUNT( args[ 3 ] ) );
    }
    else
    {
        PyObject *result = fparse_function_12_draw_tri_point_down_of_module___main__( self, args, size, NULL );
        return result;
    }

}



static PyObject *impl_function_13_draw_quad_of_module___main__( Nuitka_FunctionObject *self, PyObject *_python_par_q, PyObject *_python_par_c )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par_q( const_str_plain_q, _python_par_q );
    PyObjectLocalParameterVariableNoDel par_c( const_str_plain_c, _python_par_c );
    PyObjectLocalVariable var_inside( const_str_plain_inside );
    PyObjectLocalVariable var_ul( const_str_plain_ul );
    PyObjectLocalVariable var_ur( const_str_plain_ur );
    PyObjectLocalVariable var_br( const_str_plain_br );
    PyObjectLocalVariable var_bl( const_str_plain_bl );
    PyObjectTempVariable tmp_for_loop_1__iter_value;

    // Actual function code.
    static PyFrameObject *frame_function_13_draw_quad_of_module___main__ = NULL;

    if ( isFrameUnusable( frame_function_13_draw_quad_of_module___main__ ) )
    {
        if ( frame_function_13_draw_quad_of_module___main__ )
        {
#if _DEBUG_REFRAME
            puts( "reframe for function_13_draw_quad_of_module___main__" );
#endif
            Py_DECREF( frame_function_13_draw_quad_of_module___main__ );
        }

        frame_function_13_draw_quad_of_module___main__ = MAKE_FRAME( codeobj_e1f5356eec7efe31f8ccea97758f324b, module___main__ );
    }

    FrameGuard frame_guard( frame_function_13_draw_quad_of_module___main__ );
    try
    {
        assert( Py_REFCNT( frame_function_13_draw_quad_of_module___main__ ) == 2 ); // Frame stack
        frame_guard.setLineNumber( 244 );
        {
            PyObjectTempKeeper1 call1;
            DECREASE_REFCOUNT( ( call1.assign( LOOKUP_ATTRIBUTE( par_q.asObject0(), const_str_plain_calc_corners ) ), CALL_FUNCTION_WITH_ARGS1( call1.asObject0(), par_c.asObject0() ) ) );
        }
        var_inside.assign0( Py_False );
        frame_guard.setLineNumber( 246 );
        PyObjectTemporaryWithDel tmp_for_loop_1__for_iterator( MAKE_ITERATOR( PyObjectTemporary( LOOKUP_ATTRIBUTE( par_q.asObject0(), const_str_plain_corners ) ).asObject0() ) );
        PythonExceptionKeeper _caught_1;
#if PYTHON_VERSION < 300
        int _at_lineno_1 = 0;
#endif


        try
        {
            // Tried block:
            while( true )
            {
                frame_guard.setLineNumber( 246 );
                PyObject *_tmp_unpack_2 = ITERATOR_NEXT( tmp_for_loop_1__for_iterator.asObject0() );

                if ( _tmp_unpack_2 == NULL )
                {
                    break;
                }
                tmp_for_loop_1__iter_value.assign1( _tmp_unpack_2 );
                par_c.assign0( tmp_for_loop_1__iter_value.asObject0() );
                frame_guard.setLineNumber( 247 );
                {
                    PyObjectTempKeeper1 cmp1;
                    PyObjectTempKeeper1 cmp2;
                    if ( ( RICH_COMPARE_BOOL_GE( PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_0, 0 ) ).asObject0(), const_int_0 ) && ( ( cmp1.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_0, 0 ) ), RICH_COMPARE_BOOL_LT( cmp1.asObject0(), GET_MODULE_VALUE0( const_str_plain_s_w ) ) ) && ( RICH_COMPARE_BOOL_GE( PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_1, 1 ) ).asObject0(), const_int_0 ) && ( ( cmp2.assign( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_1, 1 ) ), RICH_COMPARE_BOOL_LT( cmp2.asObject0(), GET_MODULE_VALUE0( const_str_plain_s_h ) ) ) && ( RICH_COMPARE_BOOL_GT( PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_2, 2 ) ).asObject0(), const_int_0 ) && RICH_COMPARE_BOOL_LT( PyObjectTemporary( BINARY_OPERATION_MUL( PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( par_c.asObject0(), const_int_pos_2, 2 ) ).asObject0(), const_int_pos_30 ) ).asObject0(), const_int_pos_50 ) ) ) ) ) ) )
                    {
                        var_inside.assign0( Py_True );
                        frame_guard.setLineNumber( 249 );
                        break;
                    }
                }

                CONSIDER_THREADING();
            }
        }
        catch ( PythonException &_exception )
        {
#if PYTHON_VERSION >= 300
            if ( !_exception.hasTraceback() )
            {
                _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
            }
            else
            {
                _exception.addTraceback( frame_guard.getFrame0() );
            }
#else
            _at_lineno_1 = frame_guard.getLineNumber();
#endif

            _caught_1.save( _exception );

#if PYTHON_VERSION >= 300
            frame_guard.preserveExistingException();

            _exception.toExceptionHandler();
#endif
        }

        // Final block:
        tmp_for_loop_1__iter_value.del( true );
        tmp_for_loop_1__for_iterator.del( false );
#if PYTHON_VERSION < 300
        if ( _at_lineno_1 != 0 )
        {
           frame_guard.setLineNumber( _at_lineno_1 );
        }
#endif
        _caught_1.rethrow();
        // Final end
        frame_guard.setLineNumber( 250 );
        if ( (!( CHECK_IF_TRUE( var_inside.asObject0() ) )) )
        {
            return INCREASE_REFCOUNT( Py_None );
        }
        frame_guard.setLineNumber( 252 );
        {
            PyObjectTempKeeper0 isinstance1;
            if ( ( isinstance1.assign( par_q.asObject0() ), BUILTIN_ISINSTANCE_BOOL( isinstance1.asObject0(), GET_MODULE_VALUE0( const_str_plain_Tri ) ) ) )
            {
                frame_guard.setLineNumber( 253 );
                {
                    PyObjectTempKeeper0 call1;
                    PyObjectTempKeeper1 call2;
                    PyObjectTempKeeper1 call3;
                    PyObjectTempKeeper1 call4;
                    return ( call1.assign( GET_MODULE_VALUE0( const_str_plain_draw_tri ) ), call2.assign( LOOKUP_SUBSCRIPT_CONST( PyObjectTemporary( LOOKUP_ATTRIBUTE( par_q.asObject0(), const_str_plain_corners ) ).asObject0(), const_int_0, 0 ) ), call3.assign( LOOKUP_SUBSCRIPT_CONST( PyObjectTemporary( LOOKUP_ATTRIBUTE( par_q.asObject0(), const_str_plain_corners ) ).asObject0(), const_int_pos_1, 1 ) ), call4.assign( LOOKUP_SUBSCRIPT_CONST( PyObjectTemporary( LOOKUP_ATTRIBUTE( par_q.asObject0(), const_str_plain_corners ) ).asObject0(), const_int_pos_2, 2 ) ), CALL_FUNCTION_WITH_ARGS4( call1.asObject0(), call2.asObject0(), call3.asObject0(), call4.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( par_q.asObject0(), const_str_plain_texture ) ).asObject0() ) );
                }
            }
        }
        frame_guard.setLineNumber( 254 );
        var_ul.assign1( LOOKUP_SUBSCRIPT_CONST( PyObjectTemporary( LOOKUP_ATTRIBUTE( par_q.asObject0(), const_str_plain_corners ) ).asObject0(), const_int_0, 0 ) );
        frame_guard.setLineNumber( 255 );
        var_ur.assign1( LOOKUP_SUBSCRIPT_CONST( PyObjectTemporary( LOOKUP_ATTRIBUTE( par_q.asObject0(), const_str_plain_corners ) ).asObject0(), const_int_pos_1, 1 ) );
        frame_guard.setLineNumber( 256 );
        var_br.assign1( LOOKUP_SUBSCRIPT_CONST( PyObjectTemporary( LOOKUP_ATTRIBUTE( par_q.asObject0(), const_str_plain_corners ) ).asObject0(), const_int_pos_2, 2 ) );
        frame_guard.setLineNumber( 257 );
        var_bl.assign1( LOOKUP_SUBSCRIPT_CONST( PyObjectTemporary( LOOKUP_ATTRIBUTE( par_q.asObject0(), const_str_plain_corners ) ).asObject0(), const_int_pos_3, 3 ) );
        frame_guard.setLineNumber( 258 );
        {
            PyObjectTempKeeper0 call1;
            PyObjectTempKeeper0 call2;
            PyObjectTempKeeper0 call3;
            PyObjectTempKeeper0 call4;
            DECREASE_REFCOUNT( ( call1.assign( GET_MODULE_VALUE0( const_str_plain_draw_tri ) ), call2.assign( var_ul.asObject0() ), call3.assign( var_ur.asObject0() ), call4.assign( var_br.asObject0() ), CALL_FUNCTION_WITH_ARGS4( call1.asObject0(), call2.asObject0(), call3.asObject0(), call4.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( par_q.asObject0(), const_str_plain_texture ) ).asObject0() ) ) );
        }
        frame_guard.setLineNumber( 259 );
        {
            PyObjectTempKeeper0 call1;
            PyObjectTempKeeper0 call2;
            PyObjectTempKeeper0 call3;
            PyObjectTempKeeper0 call4;
            DECREASE_REFCOUNT( ( call1.assign( GET_MODULE_VALUE0( const_str_plain_draw_tri ) ), call2.assign( var_ul.asObject0() ), call3.assign( var_br.asObject0() ), call4.assign( var_bl.asObject0() ), CALL_FUNCTION_WITH_ARGS4( call1.asObject0(), call2.asObject0(), call3.asObject0(), call4.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( par_q.asObject0(), const_str_plain_texture ) ).asObject0() ) ) );
        }
    }
    catch ( PythonException &_exception )
    {
        if ( !_exception.hasTraceback() )
        {
            _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
        }
        else
        {
            _exception.addTraceback( frame_guard.getFrame0() );
        }

        Py_XDECREF( frame_guard.getFrame0()->f_locals );
        frame_guard.getFrame0()->f_locals = par_c.updateLocalsDict( par_q.updateLocalsDict( var_bl.updateLocalsDict( var_br.updateLocalsDict( var_ur.updateLocalsDict( var_ul.updateLocalsDict( var_inside.updateLocalsDict( PyDict_New() ) ) ) ) ) ) );

        if ( frame_guard.getFrame0() == frame_function_13_draw_quad_of_module___main__ )
        {
           Py_DECREF( frame_function_13_draw_quad_of_module___main__ );
           frame_function_13_draw_quad_of_module___main__ = NULL;
        }

        _exception.toPython();
        return NULL;
    }
    return INCREASE_REFCOUNT( Py_None );
}
static PyObject *fparse_function_13_draw_quad_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, Py_ssize_t args_size, PyObject *kw )
{
    assert( kw == NULL || PyDict_Check( kw ) );

    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_size = kw ? PyDict_Size( kw ) : 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_found = 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_only_found = 0;
    Py_ssize_t args_given = args_size;
    PyObject *_python_par_q = NULL;
    PyObject *_python_par_c = NULL;
    // Copy given dictionary values to the the respective variables:
    if ( kw_size > 0 )
    {
        Py_ssize_t ppos = 0;
        PyObject *key, *value;

        while( PyDict_Next( kw, &ppos, &key, &value ) )
        {
#if PYTHON_VERSION < 300
            if (unlikely( !PyString_Check( key ) && !PyUnicode_Check( key ) ))
#else
            if (unlikely( !PyUnicode_Check( key ) ))
#endif
            {
                PyErr_Format( PyExc_TypeError, "draw_quad() keywords must be strings" );
                goto error_exit;
            }

            NUITKA_MAY_BE_UNUSED bool found = false;

            Py_INCREF( key );
            Py_INCREF( value );

            // Quick path, could be our value.
            if ( found == false && const_str_plain_q == key )
            {
                assert( _python_par_q == NULL );
                _python_par_q = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && const_str_plain_c == key )
            {
                assert( _python_par_c == NULL );
                _python_par_c = value;

                found = true;
                kw_found += 1;
            }

            // Slow path, compare against all parameter names.
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_q, key ) )
            {
                assert( _python_par_q == NULL );
                _python_par_q = value;

                found = true;
                kw_found += 1;
            }
            if ( found == false && RICH_COMPARE_BOOL_EQ_PARAMETERS( const_str_plain_c, key ) )
            {
                assert( _python_par_c == NULL );
                _python_par_c = value;

                found = true;
                kw_found += 1;
            }


            Py_DECREF( key );

            if ( found == false )
            {
               Py_DECREF( value );

               PyErr_Format(
                   PyExc_TypeError,
                   "draw_quad() got an unexpected keyword argument '%s'",
                   Nuitka_String_Check( key ) ? Nuitka_String_AsString( key ) : "<non-string>"
               );

               goto error_exit;
            }
        }

#if PYTHON_VERSION < 300
        assert( kw_found == kw_size );
        assert( kw_only_found == 0 );
#endif
    }

    // Check if too many arguments were given in case of non star args
    if (unlikely( args_given > 2 ))
    {
#if PYTHON_VERSION < 270
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_size );
#elif PYTHON_VERSION < 330
        ERROR_TOO_MANY_ARGUMENTS( self, args_given + kw_found );
#else
        ERROR_TOO_MANY_ARGUMENTS( self, args_given, kw_only_found );
#endif
        goto error_exit;
    }


    // Copy normal parameter values given as part of the args list to the respective variables:

    if (likely( 0 < args_given ))
    {
         if (unlikely( _python_par_q != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 0 );
             goto error_exit;
         }

        _python_par_q = INCREASE_REFCOUNT( args[ 0 ] );
    }
    else if ( _python_par_q == NULL )
    {
        if ( 0 + self->m_defaults_given >= 2  )
        {
            _python_par_q = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 0 - 2 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }
    if (likely( 1 < args_given ))
    {
         if (unlikely( _python_par_c != NULL ))
         {
             ERROR_MULTIPLE_VALUES( self, 1 );
             goto error_exit;
         }

        _python_par_c = INCREASE_REFCOUNT( args[ 1 ] );
    }
    else if ( _python_par_c == NULL )
    {
        if ( 1 + self->m_defaults_given >= 2  )
        {
            _python_par_c = INCREASE_REFCOUNT( PyTuple_GET_ITEM( self->m_defaults, self->m_defaults_given + 1 - 2 ) );
        }
#if PYTHON_VERSION < 330
        else
        {
#if PYTHON_VERSION < 270
            ERROR_TOO_FEW_ARGUMENTS( self, kw_size, args_given + kw_found );
#elif PYTHON_VERSION < 300
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found );
#else
            ERROR_TOO_FEW_ARGUMENTS( self, args_given + kw_found - kw_only_found );
#endif

            goto error_exit;
        }
#endif
    }

#if PYTHON_VERSION >= 330
    if (unlikely( _python_par_q == NULL || _python_par_c == NULL ))
    {
        PyObject *values[] = { _python_par_q, _python_par_c };
        ERROR_TOO_FEW_ARGUMENTS( self, values );

        goto error_exit;
    }
#endif


    return impl_function_13_draw_quad_of_module___main__( self, _python_par_q, _python_par_c );

error_exit:;

    Py_XDECREF( _python_par_q );
    Py_XDECREF( _python_par_c );

    return NULL;
}

static PyObject *dparse_function_13_draw_quad_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, int size )
{
    if ( size == 2 )
    {
        return impl_function_13_draw_quad_of_module___main__( self, INCREASE_REFCOUNT( args[ 0 ] ), INCREASE_REFCOUNT( args[ 1 ] ) );
    }
    else
    {
        PyObject *result = fparse_function_13_draw_quad_of_module___main__( self, args, size, NULL );
        return result;
    }

}



static PyObject *impl_function_14_main_of_module___main__( Nuitka_FunctionObject *self )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalVariable var_textures( const_str_plain_textures );
    PyObjectLocalVariable var_fn( const_str_plain_fn );
    PyObjectLocalVariable var_objects( const_str_plain_objects );
    PyObjectLocalVariable var_next_update( const_str_plain_next_update );
    PyObjectLocalVariable var_running( const_str_plain_running );
    PyObjectLocalVariable var_quads( const_str_plain_quads );
    PyObjectLocalVariable var_dt( const_str_plain_dt );
    PyObjectLocalVariable var_e( const_str_plain_e );
    PyObjectLocalVariable var_i( const_str_plain_i );
    PyObjectLocalVariable var_keys( const_str_plain_keys );
    PyObjectLocalVariable var_spd( const_str_plain_spd );
    PyObjectLocalVariable var_surf( const_str_plain_surf );
    PyObjectLocalVariable var_quad( const_str_plain_quad );
    PyObjectLocalVariable var_q( const_str_plain_q );
    PyObjectTempVariable tmp_for_loop_1__iter_value;
    PyObjectTempVariable tmp_for_loop_2__iter_value;
    PyObjectTempVariable tmp_for_loop_3__iter_value;

    // Actual function code.
    var_textures.assign1( PyDict_New() );
    static PyFrameObject *frame_function_14_main_of_module___main__ = NULL;

    if ( isFrameUnusable( frame_function_14_main_of_module___main__ ) )
    {
        if ( frame_function_14_main_of_module___main__ )
        {
#if _DEBUG_REFRAME
            puts( "reframe for function_14_main_of_module___main__" );
#endif
            Py_DECREF( frame_function_14_main_of_module___main__ );
        }

        frame_function_14_main_of_module___main__ = MAKE_FRAME( codeobj_6b81033c6ea31bb6b5d26f04e199e61a, module___main__ );
    }

    FrameGuard frame_guard( frame_function_14_main_of_module___main__ );
    try
    {
        assert( Py_REFCNT( frame_function_14_main_of_module___main__ ) == 2 ); // Frame stack
        frame_guard.setLineNumber( 263 );
        PyObjectTemporaryWithDel tmp_for_loop_1__for_iterator( MAKE_ITERATOR( PyObjectTemporary( CALL_FUNCTION_WITH_ARGS1( PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_os ), const_str_plain_listdir ) ).asObject0(), const_str_dot ) ).asObject0() ) );
        PythonExceptionKeeper _caught_1;
#if PYTHON_VERSION < 300
        int _at_lineno_1 = 0;
#endif


        try
        {
            // Tried block:
            while( true )
            {
                frame_guard.setLineNumber( 263 );
                PyObject *_tmp_unpack_2 = ITERATOR_NEXT( tmp_for_loop_1__for_iterator.asObject0() );

                if ( _tmp_unpack_2 == NULL )
                {
                    break;
                }
                tmp_for_loop_1__iter_value.assign1( _tmp_unpack_2 );
                var_fn.assign0( tmp_for_loop_1__iter_value.asObject0() );
                frame_guard.setLineNumber( 264 );
                if ( ( CHECK_IF_TRUE( PyObjectTemporary( CALL_FUNCTION_WITH_ARGS1( PyObjectTemporary( LOOKUP_ATTRIBUTE( var_fn.asObject0(), const_str_plain_endswith ) ).asObject0(), const_str_digest_06adcbfe4f995d72e50498d910d95719 ) ).asObject0() ) || CHECK_IF_TRUE( PyObjectTemporary( CALL_FUNCTION_WITH_ARGS1( PyObjectTemporary( LOOKUP_ATTRIBUTE( var_fn.asObject0(), const_str_plain_endswith ) ).asObject0(), const_str_digest_ea3a4a001f1b4ae94dae03e324cfc4eb ) ).asObject0() ) ) )
                {
                    frame_guard.setLineNumber( 265 );
                    {
                        PyObjectTempKeeper0 call1;
                        {
                            PyObjectTemporary tmp_identifier( ( call1.assign( GET_MODULE_VALUE0( const_str_plain_load_tex ) ), CALL_FUNCTION_WITH_ARGS1( call1.asObject0(), var_fn.asObject0() ) ) );
                            PyObject *tmp_subscribed = var_textures.asObject0();
                            SET_SUBSCRIPT( tmp_identifier.asObject0(), tmp_subscribed, var_fn.asObject0() );
                        }
                    }
                }

                CONSIDER_THREADING();
            }
        }
        catch ( PythonException &_exception )
        {
#if PYTHON_VERSION >= 300
            if ( !_exception.hasTraceback() )
            {
                _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
            }
            else
            {
                _exception.addTraceback( frame_guard.getFrame0() );
            }
#else
            _at_lineno_1 = frame_guard.getLineNumber();
#endif

            _caught_1.save( _exception );

#if PYTHON_VERSION >= 300
            frame_guard.preserveExistingException();

            _exception.toExceptionHandler();
#endif
        }

        // Final block:
        tmp_for_loop_1__iter_value.del( true );
        tmp_for_loop_1__for_iterator.del( false );
#if PYTHON_VERSION < 300
        if ( _at_lineno_1 != 0 )
        {
           frame_guard.setLineNumber( _at_lineno_1 );
        }
#endif
        _caught_1.rethrow();
        // Final end
        var_objects.assign1( PyList_New( 0 ) );
        frame_guard.setLineNumber( 267 );
        PyObjectTemporaryWithDel tmp_for_loop_2__for_iterator( MAKE_ITERATOR( PyObjectTemporary( CALL_FUNCTION_WITH_ARGS1( PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_os ), const_str_plain_listdir ) ).asObject0(), const_str_dot ) ).asObject0() ) );
        PythonExceptionKeeper _caught_3;
#if PYTHON_VERSION < 300
        int _at_lineno_3 = 0;
#endif


        try
        {
            // Tried block:
            while( true )
            {
                frame_guard.setLineNumber( 267 );
                PyObject *_tmp_unpack_4 = ITERATOR_NEXT( tmp_for_loop_2__for_iterator.asObject0() );

                if ( _tmp_unpack_4 == NULL )
                {
                    break;
                }
                tmp_for_loop_2__iter_value.assign1( _tmp_unpack_4 );
                var_fn.assign0( tmp_for_loop_2__iter_value.asObject0() );
                frame_guard.setLineNumber( 268 );
                if ( CHECK_IF_TRUE( PyObjectTemporary( CALL_FUNCTION_WITH_ARGS1( PyObjectTemporary( LOOKUP_ATTRIBUTE( var_fn.asObject0(), const_str_plain_endswith ) ).asObject0(), const_str_digest_de4afc0c648144cab34fa3fe881eaa1c ) ).asObject0() ) )
                {
                    frame_guard.setLineNumber( 269 );
                    {
                        PyObjectTempKeeper0 call1;
                        PyObjectTempKeeper0 call2;
                        PyObjectTempKeeper1 call3;
                        DECREASE_REFCOUNT( ( call3.assign( LOOKUP_ATTRIBUTE( var_objects.asObject0(), const_str_plain_append ) ), CALL_FUNCTION_WITH_ARGS1( call3.asObject0(), PyObjectTemporary( ( call1.assign( GET_MODULE_VALUE0( const_str_plain_load_obj ) ), call2.assign( var_fn.asObject0() ), CALL_FUNCTION_WITH_ARGS2( call1.asObject0(), call2.asObject0(), var_textures.asObject0() ) ) ).asObject0() ) ) );
                    }
                }

                CONSIDER_THREADING();
            }
        }
        catch ( PythonException &_exception )
        {
#if PYTHON_VERSION >= 300
            if ( !_exception.hasTraceback() )
            {
                _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
            }
            else
            {
                _exception.addTraceback( frame_guard.getFrame0() );
            }
#else
            _at_lineno_3 = frame_guard.getLineNumber();
#endif

            _caught_3.save( _exception );

#if PYTHON_VERSION >= 300
            frame_guard.preserveExistingException();

            _exception.toExceptionHandler();
#endif
        }

        // Final block:
        tmp_for_loop_2__iter_value.del( true );
        tmp_for_loop_2__for_iterator.del( false );
#if PYTHON_VERSION < 300
        if ( _at_lineno_3 != 0 )
        {
           frame_guard.setLineNumber( _at_lineno_3 );
        }
#endif
        _caught_3.rethrow();
        // Final end
        var_next_update.assign0( const_int_pos_1 );
        var_running.assign0( const_int_pos_1 );
        frame_guard.setLineNumber( 272 );
        var_quads.assign1( LOOKUP_SUBSCRIPT_CONST( var_objects.asObject0(), const_int_0, 0 ) );
        frame_guard.setLineNumber( 273 );
        SET_ATTRIBUTE( const_int_0, GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_points );
        frame_guard.setLineNumber( 274 );
        SET_ATTRIBUTE( const_int_0, GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_hidden );
        while( true )
        {
            frame_guard.setLineNumber( 275 );
            if ( (!( CHECK_IF_TRUE( var_running.asObject0() ) )) )
            {
                break;
            }
            frame_guard.setLineNumber( 276 );
            var_dt.assign1( CALL_FUNCTION_WITH_ARGS1( PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_clock ), const_str_plain_tick ) ).asObject0(), const_int_pos_60 ) );
            frame_guard.setLineNumber( 277 );
            {
                PyObjectTempKeeper1 call1;
                PyObjectTempKeeper1 make_tuple1;
                PyObjectTempKeeper1 make_tuple2;
                PyObjectTempKeeper1 make_tuple3;
                DECREASE_REFCOUNT( ( call1.assign( LOOKUP_ATTRIBUTE( PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_display ) ).asObject0(), const_str_plain_set_caption ) ), CALL_FUNCTION_WITH_ARGS1( call1.asObject0(), PyObjectTemporary( BINARY_OPERATION_REMAINDER( const_str_digest_d1193b7b1f9e5a5ef20d3b6356ee4fed, PyObjectTemporary( ( make_tuple1.assign( CALL_FUNCTION_NO_ARGS( PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_clock ), const_str_plain_get_fps ) ).asObject0() ) ), make_tuple2.assign( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_points ) ), make_tuple3.assign( BUILTIN_LEN( var_quads.asObject0() ) ), MAKE_TUPLE4( make_tuple1.asObject0(), make_tuple2.asObject0(), make_tuple3.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_hidden ) ).asObject0() ) ) ).asObject0() ) ).asObject0() ) ) );
            }
            frame_guard.setLineNumber( 278 );
            PyObjectTemporaryWithDel tmp_for_loop_3__for_iterator( MAKE_ITERATOR( PyObjectTemporary( CALL_FUNCTION_NO_ARGS( PyObjectTemporary( LOOKUP_ATTRIBUTE( PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_event ) ).asObject0(), const_str_plain_get ) ).asObject0() ) ).asObject0() ) );
            PythonExceptionKeeper _caught_5;
#if PYTHON_VERSION < 300
            int _at_lineno_5 = 0;
#endif


            try
            {
                // Tried block:
                while( true )
                {
                    frame_guard.setLineNumber( 278 );
                    PyObject *_tmp_unpack_6 = ITERATOR_NEXT( tmp_for_loop_3__for_iterator.asObject0() );

                    if ( _tmp_unpack_6 == NULL )
                    {
                        break;
                    }
                    tmp_for_loop_3__iter_value.assign1( _tmp_unpack_6 );
                    var_e.assign0( tmp_for_loop_3__iter_value.asObject0() );
                    frame_guard.setLineNumber( 279 );
                    {
                        PyObjectTempKeeper1 cmp1;
                        if ( ( cmp1.assign( LOOKUP_ATTRIBUTE( var_e.asObject0(), const_str_plain_type ) ), RICH_COMPARE_BOOL_EQ( cmp1.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_QUIT ) ).asObject0() ) ) )
                        {
                            var_running.assign0( const_int_0 );
                        }
                    }
                    frame_guard.setLineNumber( 285 );
                    {
                        PyObjectTempKeeper1 cmp1;
                        PyObjectTempKeeper1 cmp2;
                        if ( ( ( cmp1.assign( LOOKUP_ATTRIBUTE( var_e.asObject0(), const_str_plain_type ) ), RICH_COMPARE_BOOL_EQ( cmp1.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_KEYDOWN ) ).asObject0() ) ) && ( cmp2.assign( LOOKUP_ATTRIBUTE( var_e.asObject0(), const_str_plain_key ) ), RICH_COMPARE_BOOL_EQ( cmp2.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_K_PERIOD ) ).asObject0() ) ) ) )
                        {
                            frame_guard.setLineNumber( 286 );
                            {
                                PyObjectTempKeeper1 call1;
                                var_i.assign1( BINARY_OPERATION_SUB( PyObjectTemporary( ( call1.assign( LOOKUP_ATTRIBUTE( var_objects.asObject0(), const_str_plain_index ) ), CALL_FUNCTION_WITH_ARGS1( call1.asObject0(), var_quads.asObject0() ) ) ).asObject0(), const_int_pos_1 ) );
                            }
                            frame_guard.setLineNumber( 287 );
                            if ( RICH_COMPARE_BOOL_LT( var_i.asObject0(), const_int_0 ) )
                            {
                                frame_guard.setLineNumber( 288 );
                                var_i.assign1( BINARY_OPERATION_SUB( PyObjectTemporary( BUILTIN_LEN( var_objects.asObject0() ) ).asObject0(), const_int_pos_1 ) );
                            }
                            frame_guard.setLineNumber( 289 );
                            {
                                PyObjectTempKeeper0 subscr1;
                                var_quads.assign1( ( subscr1.assign( var_objects.asObject0() ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), var_i.asObject0() ) ) );
                            }
                        }
                    }
                    frame_guard.setLineNumber( 290 );
                    {
                        PyObjectTempKeeper1 cmp1;
                        PyObjectTempKeeper1 cmp2;
                        if ( ( ( cmp1.assign( LOOKUP_ATTRIBUTE( var_e.asObject0(), const_str_plain_type ) ), RICH_COMPARE_BOOL_EQ( cmp1.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_KEYDOWN ) ).asObject0() ) ) && ( cmp2.assign( LOOKUP_ATTRIBUTE( var_e.asObject0(), const_str_plain_key ) ), RICH_COMPARE_BOOL_EQ( cmp2.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_K_COMMA ) ).asObject0() ) ) ) )
                        {
                            frame_guard.setLineNumber( 291 );
                            {
                                PyObjectTempKeeper1 call1;
                                var_i.assign1( BINARY_OPERATION_ADD( PyObjectTemporary( ( call1.assign( LOOKUP_ATTRIBUTE( var_objects.asObject0(), const_str_plain_index ) ), CALL_FUNCTION_WITH_ARGS1( call1.asObject0(), var_quads.asObject0() ) ) ).asObject0(), const_int_pos_1 ) );
                            }
                            frame_guard.setLineNumber( 292 );
                            {
                                PyObjectTempKeeper0 cmp1;
                                if ( ( cmp1.assign( var_i.asObject0() ), RICH_COMPARE_BOOL_GE( cmp1.asObject0(), PyObjectTemporary( BUILTIN_LEN( var_objects.asObject0() ) ).asObject0() ) ) )
                                {
                                    var_i.assign0( const_int_0 );
                                }
                            }
                            frame_guard.setLineNumber( 294 );
                            {
                                PyObjectTempKeeper0 subscr1;
                                var_quads.assign1( ( subscr1.assign( var_objects.asObject0() ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), var_i.asObject0() ) ) );
                            }
                        }
                    }
                    frame_guard.setLineNumber( 295 );
                    {
                        PyObjectTempKeeper1 cmp1;
                        PyObjectTempKeeper1 cmp2;
                        if ( ( ( cmp1.assign( LOOKUP_ATTRIBUTE( var_e.asObject0(), const_str_plain_type ) ), RICH_COMPARE_BOOL_EQ( cmp1.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_KEYDOWN ) ).asObject0() ) ) && ( cmp2.assign( LOOKUP_ATTRIBUTE( var_e.asObject0(), const_str_plain_key ) ), RICH_COMPARE_BOOL_EQ( cmp2.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_K_F9 ) ).asObject0() ) ) ) )
                        {
                            frame_guard.setLineNumber( 296 );
                            {
                                PyObjectTempKeeper1 call1;
                                DECREASE_REFCOUNT( ( call1.assign( LOOKUP_ATTRIBUTE( PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_image ) ).asObject0(), const_str_plain_save ) ), CALL_FUNCTION_WITH_ARGS2( call1.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_screen ) ).asObject0(), const_str_digest_fbb81ba305363c8ff2a3cf9e8abbdc50 ) ) );
                            }
                        }
                    }

                    CONSIDER_THREADING();
                }
            }
            catch ( PythonException &_exception )
            {
#if PYTHON_VERSION >= 300
                if ( !_exception.hasTraceback() )
                {
                    _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
                }
                else
                {
                    _exception.addTraceback( frame_guard.getFrame0() );
                }
#else
                _at_lineno_5 = frame_guard.getLineNumber();
#endif

                _caught_5.save( _exception );

#if PYTHON_VERSION >= 300
                frame_guard.preserveExistingException();

                _exception.toExceptionHandler();
#endif
            }

            // Final block:
            tmp_for_loop_3__iter_value.del( true );
            tmp_for_loop_3__for_iterator.del( false );
#if PYTHON_VERSION < 300
            if ( _at_lineno_5 != 0 )
            {
               frame_guard.setLineNumber( _at_lineno_5 );
            }
#endif
            _caught_5.rethrow();
            // Final end
            frame_guard.setLineNumber( 297 );
            var_keys.assign1( CALL_FUNCTION_NO_ARGS( PyObjectTemporary( LOOKUP_ATTRIBUTE( PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_key ) ).asObject0(), const_str_plain_get_pressed ) ).asObject0() ) );
            var_spd.assign0( const_int_pos_5 );
            frame_guard.setLineNumber( 299 );
            {
                PyObjectTempKeeper0 subscr1;
                if ( CHECK_IF_TRUE( PyObjectTemporary( ( subscr1.assign( var_keys.asObject0() ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_K_a ) ).asObject0() ) ) ).asObject0() ) )
                {
                    frame_guard.setLineNumber( 300 );
                    DECREASE_REFCOUNT( impl_listcontr_1_of_function_14_main_of_module___main__( MAKE_ITERATOR( var_quads.asObject0() ), var_quad, var_spd ) );
                }
            }
            frame_guard.setLineNumber( 301 );
            {
                PyObjectTempKeeper0 subscr1;
                if ( CHECK_IF_TRUE( PyObjectTemporary( ( subscr1.assign( var_keys.asObject0() ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_K_z ) ).asObject0() ) ) ).asObject0() ) )
                {
                    frame_guard.setLineNumber( 302 );
                    DECREASE_REFCOUNT( impl_listcontr_2_of_function_14_main_of_module___main__( MAKE_ITERATOR( var_quads.asObject0() ), var_quad, var_spd ) );
                }
            }
            frame_guard.setLineNumber( 303 );
            {
                PyObjectTempKeeper0 subscr1;
                if ( CHECK_IF_TRUE( PyObjectTemporary( ( subscr1.assign( var_keys.asObject0() ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_K_LEFT ) ).asObject0() ) ) ).asObject0() ) )
                {
                    frame_guard.setLineNumber( 304 );
                    DECREASE_REFCOUNT( impl_listcontr_3_of_function_14_main_of_module___main__( MAKE_ITERATOR( var_quads.asObject0() ), var_quad, var_spd ) );
                }
            }
            frame_guard.setLineNumber( 305 );
            {
                PyObjectTempKeeper0 subscr1;
                if ( CHECK_IF_TRUE( PyObjectTemporary( ( subscr1.assign( var_keys.asObject0() ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_K_RIGHT ) ).asObject0() ) ) ).asObject0() ) )
                {
                    frame_guard.setLineNumber( 306 );
                    DECREASE_REFCOUNT( impl_listcontr_4_of_function_14_main_of_module___main__( MAKE_ITERATOR( var_quads.asObject0() ), var_quad, var_spd ) );
                }
            }
            frame_guard.setLineNumber( 307 );
            {
                PyObjectTempKeeper0 subscr1;
                if ( CHECK_IF_TRUE( PyObjectTemporary( ( subscr1.assign( var_keys.asObject0() ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_K_UP ) ).asObject0() ) ) ).asObject0() ) )
                {
                    frame_guard.setLineNumber( 308 );
                    DECREASE_REFCOUNT( impl_listcontr_5_of_function_14_main_of_module___main__( MAKE_ITERATOR( var_quads.asObject0() ), var_quad, var_spd ) );
                }
            }
            frame_guard.setLineNumber( 309 );
            {
                PyObjectTempKeeper0 subscr1;
                if ( CHECK_IF_TRUE( PyObjectTemporary( ( subscr1.assign( var_keys.asObject0() ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_K_DOWN ) ).asObject0() ) ) ).asObject0() ) )
                {
                    frame_guard.setLineNumber( 310 );
                    DECREASE_REFCOUNT( impl_listcontr_6_of_function_14_main_of_module___main__( MAKE_ITERATOR( var_quads.asObject0() ), var_quad, var_spd ) );
                }
            }
            frame_guard.setLineNumber( 311 );
            {
                PyObjectTempKeeper0 subscr1;
                if ( CHECK_IF_TRUE( PyObjectTemporary( ( subscr1.assign( var_keys.asObject0() ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_K_r ) ).asObject0() ) ) ).asObject0() ) )
                {
                    frame_guard.setLineNumber( 312 );
                    DECREASE_REFCOUNT( impl_listcontr_7_of_function_14_main_of_module___main__( MAKE_ITERATOR( var_quads.asObject0() ), var_q, var_quads ) );
                }
            }
            frame_guard.setLineNumber( 313 );
            {
                PyObjectTempKeeper0 subscr1;
                if ( CHECK_IF_TRUE( PyObjectTemporary( ( subscr1.assign( var_keys.asObject0() ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_K_t ) ).asObject0() ) ) ).asObject0() ) )
                {
                    frame_guard.setLineNumber( 314 );
                    DECREASE_REFCOUNT( impl_listcontr_8_of_function_14_main_of_module___main__( MAKE_ITERATOR( var_quads.asObject0() ), var_q, var_quads ) );
                }
            }
            frame_guard.setLineNumber( 315 );
            {
                PyObjectTempKeeper0 subscr1;
                if ( CHECK_IF_TRUE( PyObjectTemporary( ( subscr1.assign( var_keys.asObject0() ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_K_y ) ).asObject0() ) ) ).asObject0() ) )
                {
                    frame_guard.setLineNumber( 316 );
                    DECREASE_REFCOUNT( impl_listcontr_9_of_function_14_main_of_module___main__( MAKE_ITERATOR( var_quads.asObject0() ), var_q, var_quads ) );
                }
            }
            frame_guard.setLineNumber( 317 );
            {
                PyObjectTempKeeper0 subscr1;
                if ( CHECK_IF_TRUE( PyObjectTemporary( ( subscr1.assign( var_keys.asObject0() ), LOOKUP_SUBSCRIPT( subscr1.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_K_f ) ).asObject0() ) ) ).asObject0() ) )
                {
                    frame_guard.setLineNumber( 318 );
                    DECREASE_REFCOUNT( impl_listcontr_10_of_function_14_main_of_module___main__( MAKE_ITERATOR( var_quads.asObject0() ), var_q, var_quads ) );
                }
            }
            frame_guard.setLineNumber( 320 );
            if ( RICH_COMPARE_BOOL_LT( var_next_update.asObject0(), const_int_0 ) )
            {
                var_next_update.assign0( const_int_pos_30 );
                frame_guard.setLineNumber( 322 );
                {
                    PyObjectTempKeeper1 call1;
                    var_surf.assign1( ( call1.assign( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_softcontext ), const_str_plain_draw ) ), CALL_FUNCTION_WITH_ARGS1( call1.asObject0(), var_quads.asObject0() ) ) );
                }
                frame_guard.setLineNumber( 323 );
                {
                    PyObjectTempKeeper1 call1;
                    DECREASE_REFCOUNT( ( call1.assign( LOOKUP_ATTRIBUTE( PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_screen ) ).asObject0(), const_str_plain_blit ) ), CALL_FUNCTION_WITH_ARGS2( call1.asObject0(), GET_MODULE_VALUE0( const_str_plain_bg1 ), PyObjectTemporary( LIST_COPY( const_list_int_0_int_0_list ) ).asObject0() ) ) );
                }
                frame_guard.setLineNumber( 324 );
                {
                    PyObjectTempKeeper1 call1;
                    DECREASE_REFCOUNT( ( call1.assign( LOOKUP_ATTRIBUTE( PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_screen ) ).asObject0(), const_str_plain_blit ) ), CALL_FUNCTION_WITH_ARGS2( call1.asObject0(), var_surf.asObject0(), PyObjectTemporary( LIST_COPY( const_list_int_pos_32_int_pos_16_list ) ).asObject0() ) ) );
                }
                frame_guard.setLineNumber( 325 );
                {
                    PyObjectTempKeeper1 call1;
                    DECREASE_REFCOUNT( ( call1.assign( LOOKUP_ATTRIBUTE( PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_screen ) ).asObject0(), const_str_plain_blit ) ), CALL_FUNCTION_WITH_ARGS2( call1.asObject0(), GET_MODULE_VALUE0( const_str_plain_bg2 ), PyObjectTemporary( LIST_COPY( const_list_int_0_int_0_list ) ).asObject0() ) ) );
                }
            }
            frame_guard.setLineNumber( 326 );
            PyObject *tmp_inplace_assign_1__inplace_start = var_next_update.asObject0();
            PyObject *_tmp_inplace_assign_1__inplace_end;
            {
                PyObjectTempKeeper0 op1;
                _tmp_inplace_assign_1__inplace_end = ( op1.assign( tmp_inplace_assign_1__inplace_start ), BINARY_OPERATION( PyNumber_InPlaceSubtract, op1.asObject0(), var_dt.asObject0() ) );
            }
            PyObjectTemporary tmp_inplace_assign_1__inplace_end( _tmp_inplace_assign_1__inplace_end );
            if ( ( tmp_inplace_assign_1__inplace_start != tmp_inplace_assign_1__inplace_end.asObject0() ) )
            {
                var_next_update.assign0( tmp_inplace_assign_1__inplace_end.asObject0() );
            }
            frame_guard.setLineNumber( 327 );
            DECREASE_REFCOUNT( CALL_FUNCTION_NO_ARGS( PyObjectTemporary( LOOKUP_ATTRIBUTE( PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_display ) ).asObject0(), const_str_plain_flip ) ).asObject0() ) );

            CONSIDER_THREADING();
        }
    }
    catch ( PythonException &_exception )
    {
        if ( !_exception.hasTraceback() )
        {
            _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
        }
        else
        {
            _exception.addTraceback( frame_guard.getFrame0() );
        }

        Py_XDECREF( frame_guard.getFrame0()->f_locals );
        frame_guard.getFrame0()->f_locals = var_q.updateLocalsDict( var_quad.updateLocalsDict( var_surf.updateLocalsDict( var_spd.updateLocalsDict( var_keys.updateLocalsDict( var_i.updateLocalsDict( var_e.updateLocalsDict( var_dt.updateLocalsDict( var_quads.updateLocalsDict( var_running.updateLocalsDict( var_next_update.updateLocalsDict( var_objects.updateLocalsDict( var_fn.updateLocalsDict( var_textures.updateLocalsDict( PyDict_New() ) ) ) ) ) ) ) ) ) ) ) ) ) );

        if ( frame_guard.getFrame0() == frame_function_14_main_of_module___main__ )
        {
           Py_DECREF( frame_function_14_main_of_module___main__ );
           frame_function_14_main_of_module___main__ = NULL;
        }

        _exception.toPython();
        return NULL;
    }
    return INCREASE_REFCOUNT( Py_None );
}
static PyObject *fparse_function_14_main_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, Py_ssize_t args_size, PyObject *kw )
{
    assert( kw == NULL || PyDict_Check( kw ) );

    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_size = kw ? PyDict_Size( kw ) : 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_found = 0;
    NUITKA_MAY_BE_UNUSED Py_ssize_t kw_only_found = 0;
    Py_ssize_t args_given = args_size;

    if (unlikely( args_given + kw_size > 0 ))
    {
#if PYTHON_VERSION < 330
        ERROR_NO_ARGUMENTS_ALLOWED(
           self,
           args_given + kw_size
        );
#else
        ERROR_NO_ARGUMENTS_ALLOWED(
           self,
           kw_size > 0 ? kw : NULL,
           args_given
        );
#endif

        goto error_exit;
    }


    return impl_function_14_main_of_module___main__( self );

error_exit:;


    return NULL;
}

static PyObject *dparse_function_14_main_of_module___main__( Nuitka_FunctionObject *self, PyObject **args, int size )
{
    if ( size == 0 )
    {
        return impl_function_14_main_of_module___main__( self );
    }
    else
    {
        PyObject *result = fparse_function_14_main_of_module___main__( self, args, size, NULL );
        return result;
    }

}



NUITKA_LOCAL_MODULE PyObject *impl_listcontr_1_of_function_14_main_of_module___main__( PyObject *_python_par___iterator, PyObjectLocalVariable &closure_quad, PyObjectLocalVariable &closure_spd )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par___iterator( const_str_plain__SoftContext__iterator, _python_par___iterator );
    PyObjectTempVariable tmp_iter_value_0;

    // Actual function code.
    PyObjectTemporary tmp_result( PyList_New( 0 ) );
    FrameGuardVeryLight frame_guard;

    frame_guard.setLineNumber( 300 );
    PyObject *tmp_contraction_iter_0 = par___iterator.asObject0();
    while( true )
    {
        frame_guard.setLineNumber( 300 );
        PyObject *_tmp_unpack_1 = ITERATOR_NEXT( tmp_contraction_iter_0 );

        if ( _tmp_unpack_1 == NULL )
        {
            break;
        }
        tmp_iter_value_0.assign1( _tmp_unpack_1 );
        closure_quad.assign0( tmp_iter_value_0.asObject0() );
        {
            PyObjectTempKeeper0 call1;
            PyObjectTempKeeper1 call2;
            APPEND_TO_LIST( tmp_result.asObject0(), PyObjectTemporary( ( call1.assign( GET_MODULE_VALUE0( const_str_plain_trans ) ), call2.assign( MAKE_TUPLE1( closure_quad.asObject0() ) ), CALL_FUNCTION( call1.asObject0(), call2.asObject0(), PyObjectTemporary( MAKE_DICT1( PyObjectTemporary( UNARY_OPERATION( PyNumber_Negative, closure_spd.asObject0() ) ).asObject0(), const_str_plain_z ) ).asObject0() ) ) ).asObject0() ), Py_None;
        }

        CONSIDER_THREADING();
    }
    tmp_contraction_iter_0 = NULL;
    return tmp_result.asObject1();
}


NUITKA_LOCAL_MODULE PyObject *impl_listcontr_2_of_function_14_main_of_module___main__( PyObject *_python_par___iterator, PyObjectLocalVariable &closure_quad, PyObjectLocalVariable &closure_spd )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par___iterator( const_str_plain__SoftContext__iterator, _python_par___iterator );
    PyObjectTempVariable tmp_iter_value_0;

    // Actual function code.
    PyObjectTemporary tmp_result( PyList_New( 0 ) );
    FrameGuardVeryLight frame_guard;

    frame_guard.setLineNumber( 302 );
    PyObject *tmp_contraction_iter_0 = par___iterator.asObject0();
    while( true )
    {
        frame_guard.setLineNumber( 302 );
        PyObject *_tmp_unpack_1 = ITERATOR_NEXT( tmp_contraction_iter_0 );

        if ( _tmp_unpack_1 == NULL )
        {
            break;
        }
        tmp_iter_value_0.assign1( _tmp_unpack_1 );
        closure_quad.assign0( tmp_iter_value_0.asObject0() );
        {
            PyObjectTempKeeper0 call1;
            PyObjectTempKeeper1 call2;
            APPEND_TO_LIST( tmp_result.asObject0(), PyObjectTemporary( ( call1.assign( GET_MODULE_VALUE0( const_str_plain_trans ) ), call2.assign( MAKE_TUPLE1( closure_quad.asObject0() ) ), CALL_FUNCTION( call1.asObject0(), call2.asObject0(), PyObjectTemporary( MAKE_DICT1( closure_spd.asObject0(), const_str_plain_z ) ).asObject0() ) ) ).asObject0() ), Py_None;
        }

        CONSIDER_THREADING();
    }
    tmp_contraction_iter_0 = NULL;
    return tmp_result.asObject1();
}


NUITKA_LOCAL_MODULE PyObject *impl_listcontr_3_of_function_14_main_of_module___main__( PyObject *_python_par___iterator, PyObjectLocalVariable &closure_quad, PyObjectLocalVariable &closure_spd )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par___iterator( const_str_plain__SoftContext__iterator, _python_par___iterator );
    PyObjectTempVariable tmp_iter_value_0;

    // Actual function code.
    PyObjectTemporary tmp_result( PyList_New( 0 ) );
    FrameGuardVeryLight frame_guard;

    frame_guard.setLineNumber( 304 );
    PyObject *tmp_contraction_iter_0 = par___iterator.asObject0();
    while( true )
    {
        frame_guard.setLineNumber( 304 );
        PyObject *_tmp_unpack_1 = ITERATOR_NEXT( tmp_contraction_iter_0 );

        if ( _tmp_unpack_1 == NULL )
        {
            break;
        }
        tmp_iter_value_0.assign1( _tmp_unpack_1 );
        closure_quad.assign0( tmp_iter_value_0.asObject0() );
        {
            PyObjectTempKeeper0 call1;
            PyObjectTempKeeper1 call2;
            APPEND_TO_LIST( tmp_result.asObject0(), PyObjectTemporary( ( call1.assign( GET_MODULE_VALUE0( const_str_plain_trans ) ), call2.assign( MAKE_TUPLE1( closure_quad.asObject0() ) ), CALL_FUNCTION( call1.asObject0(), call2.asObject0(), PyObjectTemporary( MAKE_DICT1( PyObjectTemporary( UNARY_OPERATION( PyNumber_Negative, closure_spd.asObject0() ) ).asObject0(), const_str_plain_x ) ).asObject0() ) ) ).asObject0() ), Py_None;
        }

        CONSIDER_THREADING();
    }
    tmp_contraction_iter_0 = NULL;
    return tmp_result.asObject1();
}


NUITKA_LOCAL_MODULE PyObject *impl_listcontr_4_of_function_14_main_of_module___main__( PyObject *_python_par___iterator, PyObjectLocalVariable &closure_quad, PyObjectLocalVariable &closure_spd )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par___iterator( const_str_plain__SoftContext__iterator, _python_par___iterator );
    PyObjectTempVariable tmp_iter_value_0;

    // Actual function code.
    PyObjectTemporary tmp_result( PyList_New( 0 ) );
    FrameGuardVeryLight frame_guard;

    frame_guard.setLineNumber( 306 );
    PyObject *tmp_contraction_iter_0 = par___iterator.asObject0();
    while( true )
    {
        frame_guard.setLineNumber( 306 );
        PyObject *_tmp_unpack_1 = ITERATOR_NEXT( tmp_contraction_iter_0 );

        if ( _tmp_unpack_1 == NULL )
        {
            break;
        }
        tmp_iter_value_0.assign1( _tmp_unpack_1 );
        closure_quad.assign0( tmp_iter_value_0.asObject0() );
        {
            PyObjectTempKeeper0 call1;
            PyObjectTempKeeper1 call2;
            APPEND_TO_LIST( tmp_result.asObject0(), PyObjectTemporary( ( call1.assign( GET_MODULE_VALUE0( const_str_plain_trans ) ), call2.assign( MAKE_TUPLE1( closure_quad.asObject0() ) ), CALL_FUNCTION( call1.asObject0(), call2.asObject0(), PyObjectTemporary( MAKE_DICT1( closure_spd.asObject0(), const_str_plain_x ) ).asObject0() ) ) ).asObject0() ), Py_None;
        }

        CONSIDER_THREADING();
    }
    tmp_contraction_iter_0 = NULL;
    return tmp_result.asObject1();
}


NUITKA_LOCAL_MODULE PyObject *impl_listcontr_5_of_function_14_main_of_module___main__( PyObject *_python_par___iterator, PyObjectLocalVariable &closure_quad, PyObjectLocalVariable &closure_spd )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par___iterator( const_str_plain__SoftContext__iterator, _python_par___iterator );
    PyObjectTempVariable tmp_iter_value_0;

    // Actual function code.
    PyObjectTemporary tmp_result( PyList_New( 0 ) );
    FrameGuardVeryLight frame_guard;

    frame_guard.setLineNumber( 308 );
    PyObject *tmp_contraction_iter_0 = par___iterator.asObject0();
    while( true )
    {
        frame_guard.setLineNumber( 308 );
        PyObject *_tmp_unpack_1 = ITERATOR_NEXT( tmp_contraction_iter_0 );

        if ( _tmp_unpack_1 == NULL )
        {
            break;
        }
        tmp_iter_value_0.assign1( _tmp_unpack_1 );
        closure_quad.assign0( tmp_iter_value_0.asObject0() );
        {
            PyObjectTempKeeper0 call1;
            PyObjectTempKeeper1 call2;
            APPEND_TO_LIST( tmp_result.asObject0(), PyObjectTemporary( ( call1.assign( GET_MODULE_VALUE0( const_str_plain_trans ) ), call2.assign( MAKE_TUPLE1( closure_quad.asObject0() ) ), CALL_FUNCTION( call1.asObject0(), call2.asObject0(), PyObjectTemporary( MAKE_DICT1( PyObjectTemporary( UNARY_OPERATION( PyNumber_Negative, closure_spd.asObject0() ) ).asObject0(), const_str_plain_y ) ).asObject0() ) ) ).asObject0() ), Py_None;
        }

        CONSIDER_THREADING();
    }
    tmp_contraction_iter_0 = NULL;
    return tmp_result.asObject1();
}


NUITKA_LOCAL_MODULE PyObject *impl_listcontr_6_of_function_14_main_of_module___main__( PyObject *_python_par___iterator, PyObjectLocalVariable &closure_quad, PyObjectLocalVariable &closure_spd )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par___iterator( const_str_plain__SoftContext__iterator, _python_par___iterator );
    PyObjectTempVariable tmp_iter_value_0;

    // Actual function code.
    PyObjectTemporary tmp_result( PyList_New( 0 ) );
    FrameGuardVeryLight frame_guard;

    frame_guard.setLineNumber( 310 );
    PyObject *tmp_contraction_iter_0 = par___iterator.asObject0();
    while( true )
    {
        frame_guard.setLineNumber( 310 );
        PyObject *_tmp_unpack_1 = ITERATOR_NEXT( tmp_contraction_iter_0 );

        if ( _tmp_unpack_1 == NULL )
        {
            break;
        }
        tmp_iter_value_0.assign1( _tmp_unpack_1 );
        closure_quad.assign0( tmp_iter_value_0.asObject0() );
        {
            PyObjectTempKeeper0 call1;
            PyObjectTempKeeper1 call2;
            APPEND_TO_LIST( tmp_result.asObject0(), PyObjectTemporary( ( call1.assign( GET_MODULE_VALUE0( const_str_plain_trans ) ), call2.assign( MAKE_TUPLE1( closure_quad.asObject0() ) ), CALL_FUNCTION( call1.asObject0(), call2.asObject0(), PyObjectTemporary( MAKE_DICT1( closure_spd.asObject0(), const_str_plain_y ) ).asObject0() ) ) ).asObject0() ), Py_None;
        }

        CONSIDER_THREADING();
    }
    tmp_contraction_iter_0 = NULL;
    return tmp_result.asObject1();
}


NUITKA_LOCAL_MODULE PyObject *impl_listcontr_7_of_function_14_main_of_module___main__( PyObject *_python_par___iterator, PyObjectLocalVariable &closure_q, PyObjectLocalVariable &closure_quads )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par___iterator( const_str_plain__SoftContext__iterator, _python_par___iterator );
    PyObjectTempVariable tmp_iter_value_0;

    // Actual function code.
    PyObjectTemporary tmp_result( PyList_New( 0 ) );
    FrameGuardVeryLight frame_guard;

    frame_guard.setLineNumber( 312 );
    PyObject *tmp_contraction_iter_0 = par___iterator.asObject0();
    while( true )
    {
        frame_guard.setLineNumber( 312 );
        PyObject *_tmp_unpack_1 = ITERATOR_NEXT( tmp_contraction_iter_0 );

        if ( _tmp_unpack_1 == NULL )
        {
            break;
        }
        tmp_iter_value_0.assign1( _tmp_unpack_1 );
        closure_q.assign0( tmp_iter_value_0.asObject0() );
        {
            PyObjectTempKeeper1 call1;
            APPEND_TO_LIST( tmp_result.asObject0(), PyObjectTemporary( ( call1.assign( LOOKUP_ATTRIBUTE( closure_q.asObject0(), const_str_plain_rot ) ), CALL_FUNCTION( call1.asObject0(), const_tuple_empty, PyObjectTemporary( MAKE_DICT2( const_int_pos_1, const_str_plain_ry, PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( PyObjectTemporary( LOOKUP_ATTRIBUTE( PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( closure_quads.asObject0(), const_int_0, 0 ) ).asObject0(), const_str_plain_points ) ).asObject0(), const_int_0, 0 ) ).asObject0(), const_str_plain_center ) ).asObject0() ) ) ).asObject0() ), Py_None;
        }

        CONSIDER_THREADING();
    }
    tmp_contraction_iter_0 = NULL;
    return tmp_result.asObject1();
}


NUITKA_LOCAL_MODULE PyObject *impl_listcontr_8_of_function_14_main_of_module___main__( PyObject *_python_par___iterator, PyObjectLocalVariable &closure_q, PyObjectLocalVariable &closure_quads )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par___iterator( const_str_plain__SoftContext__iterator, _python_par___iterator );
    PyObjectTempVariable tmp_iter_value_0;

    // Actual function code.
    PyObjectTemporary tmp_result( PyList_New( 0 ) );
    FrameGuardVeryLight frame_guard;

    frame_guard.setLineNumber( 314 );
    PyObject *tmp_contraction_iter_0 = par___iterator.asObject0();
    while( true )
    {
        frame_guard.setLineNumber( 314 );
        PyObject *_tmp_unpack_1 = ITERATOR_NEXT( tmp_contraction_iter_0 );

        if ( _tmp_unpack_1 == NULL )
        {
            break;
        }
        tmp_iter_value_0.assign1( _tmp_unpack_1 );
        closure_q.assign0( tmp_iter_value_0.asObject0() );
        {
            PyObjectTempKeeper1 call1;
            APPEND_TO_LIST( tmp_result.asObject0(), PyObjectTemporary( ( call1.assign( LOOKUP_ATTRIBUTE( closure_q.asObject0(), const_str_plain_rot ) ), CALL_FUNCTION( call1.asObject0(), const_tuple_empty, PyObjectTemporary( MAKE_DICT2( const_int_pos_1, const_str_plain_rx, PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( PyObjectTemporary( LOOKUP_ATTRIBUTE( PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( closure_quads.asObject0(), const_int_0, 0 ) ).asObject0(), const_str_plain_points ) ).asObject0(), const_int_0, 0 ) ).asObject0(), const_str_plain_center ) ).asObject0() ) ) ).asObject0() ), Py_None;
        }

        CONSIDER_THREADING();
    }
    tmp_contraction_iter_0 = NULL;
    return tmp_result.asObject1();
}


NUITKA_LOCAL_MODULE PyObject *impl_listcontr_9_of_function_14_main_of_module___main__( PyObject *_python_par___iterator, PyObjectLocalVariable &closure_q, PyObjectLocalVariable &closure_quads )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par___iterator( const_str_plain__SoftContext__iterator, _python_par___iterator );
    PyObjectTempVariable tmp_iter_value_0;

    // Actual function code.
    PyObjectTemporary tmp_result( PyList_New( 0 ) );
    FrameGuardVeryLight frame_guard;

    frame_guard.setLineNumber( 316 );
    PyObject *tmp_contraction_iter_0 = par___iterator.asObject0();
    while( true )
    {
        frame_guard.setLineNumber( 316 );
        PyObject *_tmp_unpack_1 = ITERATOR_NEXT( tmp_contraction_iter_0 );

        if ( _tmp_unpack_1 == NULL )
        {
            break;
        }
        tmp_iter_value_0.assign1( _tmp_unpack_1 );
        closure_q.assign0( tmp_iter_value_0.asObject0() );
        {
            PyObjectTempKeeper1 call1;
            APPEND_TO_LIST( tmp_result.asObject0(), PyObjectTemporary( ( call1.assign( LOOKUP_ATTRIBUTE( closure_q.asObject0(), const_str_plain_rot ) ), CALL_FUNCTION( call1.asObject0(), const_tuple_empty, PyObjectTemporary( MAKE_DICT2( const_int_pos_1, const_str_plain_rz, PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( PyObjectTemporary( LOOKUP_ATTRIBUTE( PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( closure_quads.asObject0(), const_int_0, 0 ) ).asObject0(), const_str_plain_points ) ).asObject0(), const_int_0, 0 ) ).asObject0(), const_str_plain_center ) ).asObject0() ) ) ).asObject0() ), Py_None;
        }

        CONSIDER_THREADING();
    }
    tmp_contraction_iter_0 = NULL;
    return tmp_result.asObject1();
}


NUITKA_LOCAL_MODULE PyObject *impl_listcontr_10_of_function_14_main_of_module___main__( PyObject *_python_par___iterator, PyObjectLocalVariable &closure_q, PyObjectLocalVariable &closure_quads )
{
    // No context is used.

    // Local variable declarations.
    PyObjectLocalParameterVariableNoDel par___iterator( const_str_plain__SoftContext__iterator, _python_par___iterator );
    PyObjectTempVariable tmp_iter_value_0;

    // Actual function code.
    PyObjectTemporary tmp_result( PyList_New( 0 ) );
    FrameGuardVeryLight frame_guard;

    frame_guard.setLineNumber( 318 );
    PyObject *tmp_contraction_iter_0 = par___iterator.asObject0();
    while( true )
    {
        frame_guard.setLineNumber( 318 );
        PyObject *_tmp_unpack_1 = ITERATOR_NEXT( tmp_contraction_iter_0 );

        if ( _tmp_unpack_1 == NULL )
        {
            break;
        }
        tmp_iter_value_0.assign1( _tmp_unpack_1 );
        closure_q.assign0( tmp_iter_value_0.asObject0() );
        {
            PyObjectTempKeeper1 call1;
            APPEND_TO_LIST( tmp_result.asObject0(), PyObjectTemporary( ( call1.assign( LOOKUP_ATTRIBUTE( closure_q.asObject0(), const_str_plain_rot ) ), CALL_FUNCTION( call1.asObject0(), const_tuple_int_neg_1_tuple, PyObjectTemporary( MAKE_DICT1( PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( PyObjectTemporary( LOOKUP_ATTRIBUTE( PyObjectTemporary( LOOKUP_SUBSCRIPT_CONST( closure_quads.asObject0(), const_int_0, 0 ) ).asObject0(), const_str_plain_points ) ).asObject0(), const_int_0, 0 ) ).asObject0(), const_str_plain_center ) ).asObject0() ) ) ).asObject0() ), Py_None;
        }

        CONSIDER_THREADING();
    }
    tmp_contraction_iter_0 = NULL;
    return tmp_result.asObject1();
}



static PyObject *MAKE_FUNCTION_function_10_draw_line_of_module___main__(  )
{
    PyObject *result = Nuitka_Function_New(
        fparse_function_10_draw_line_of_module___main__,
        dparse_function_10_draw_line_of_module___main__,
        const_str_plain_draw_line,
#if PYTHON_VERSION >= 330
        NULL,
#endif
        codeobj_ca9810658fedef00ba774394fd8ebe18,
        INCREASE_REFCOUNT( Py_None ),
#if PYTHON_VERSION >= 300
        INCREASE_REFCOUNT( Py_None ),
        NULL,
#endif
        module___main__,
        const_str_plain_horizontal
    );

    return result;
}



static PyObject *MAKE_FUNCTION_function_11_draw_tri_point_up_of_module___main__(  )
{
    PyObject *result = Nuitka_Function_New(
        fparse_function_11_draw_tri_point_up_of_module___main__,
        dparse_function_11_draw_tri_point_up_of_module___main__,
        const_str_plain_draw_tri_point_up,
#if PYTHON_VERSION >= 330
        NULL,
#endif
        codeobj_4c8ff8cf75916717befe972857d8e220,
        INCREASE_REFCOUNT( Py_None ),
#if PYTHON_VERSION >= 300
        INCREASE_REFCOUNT( Py_None ),
        NULL,
#endif
        module___main__,
        const_str_digest_5ffba3fe18a607a705fabff2aab14c6e
    );

    return result;
}



static PyObject *MAKE_FUNCTION_function_12_draw_tri_point_down_of_module___main__(  )
{
    PyObject *result = Nuitka_Function_New(
        fparse_function_12_draw_tri_point_down_of_module___main__,
        dparse_function_12_draw_tri_point_down_of_module___main__,
        const_str_plain_draw_tri_point_down,
#if PYTHON_VERSION >= 330
        NULL,
#endif
        codeobj_02001be2b1b34d108592e705e84e8777,
        INCREASE_REFCOUNT( Py_None ),
#if PYTHON_VERSION >= 300
        INCREASE_REFCOUNT( Py_None ),
        NULL,
#endif
        module___main__,
        const_str_digest_7464b3f8a6bfa21e4c5c95c65b811a6e
    );

    return result;
}



static PyObject *MAKE_FUNCTION_function_13_draw_quad_of_module___main__(  )
{
    PyObject *result = Nuitka_Function_New(
        fparse_function_13_draw_quad_of_module___main__,
        dparse_function_13_draw_quad_of_module___main__,
        const_str_plain_draw_quad,
#if PYTHON_VERSION >= 330
        NULL,
#endif
        codeobj_ff2a90f4bc2811b022cf4f4e1384372a,
        INCREASE_REFCOUNT( Py_None ),
#if PYTHON_VERSION >= 300
        INCREASE_REFCOUNT( Py_None ),
        NULL,
#endif
        module___main__,
        const_str_digest_9defd461ba0e610295d70aae28f561e5
    );

    return result;
}



static PyObject *MAKE_FUNCTION_function_14_main_of_module___main__(  )
{
    PyObject *result = Nuitka_Function_New(
        fparse_function_14_main_of_module___main__,
        dparse_function_14_main_of_module___main__,
        const_str_plain_main,
#if PYTHON_VERSION >= 330
        NULL,
#endif
        codeobj_9bdaf70f31d15b0a1942829067bcaa17,
        INCREASE_REFCOUNT( Py_None ),
#if PYTHON_VERSION >= 300
        INCREASE_REFCOUNT( Py_None ),
        NULL,
#endif
        module___main__,
        Py_None
    );

    return result;
}



static PyObject *MAKE_FUNCTION_function_1___init___of_class_1_SoftContext_of_module___main__(  )
{
    PyObject *result = Nuitka_Function_New(
        fparse_function_1___init___of_class_1_SoftContext_of_module___main__,
        dparse_function_1___init___of_class_1_SoftContext_of_module___main__,
        const_str_plain___init__,
#if PYTHON_VERSION >= 330
        NULL,
#endif
        codeobj_93bd4497cb959c6b48cad94a79a76a4b,
        INCREASE_REFCOUNT( Py_None ),
#if PYTHON_VERSION >= 300
        INCREASE_REFCOUNT( Py_None ),
        NULL,
#endif
        module___main__,
        Py_None
    );

    return result;
}



static PyObject *MAKE_FUNCTION_function_2_load_tex_of_module___main__(  )
{
    PyObject *result = Nuitka_Function_New(
        fparse_function_2_load_tex_of_module___main__,
        dparse_function_2_load_tex_of_module___main__,
        const_str_plain_load_tex,
#if PYTHON_VERSION >= 330
        NULL,
#endif
        codeobj_3ea4006a159a6f483a66f0474ae72c69,
        INCREASE_REFCOUNT( Py_None ),
#if PYTHON_VERSION >= 300
        INCREASE_REFCOUNT( Py_None ),
        NULL,
#endif
        module___main__,
        Py_None
    );

    return result;
}



static PyObject *MAKE_FUNCTION_function_2_trans_of_class_1_SoftContext_of_module___main__(  )
{
    PyObject *result = Nuitka_Function_New(
        fparse_function_2_trans_of_class_1_SoftContext_of_module___main__,
        dparse_function_2_trans_of_class_1_SoftContext_of_module___main__,
        const_str_plain_trans,
#if PYTHON_VERSION >= 330
        NULL,
#endif
        codeobj_af7f00e2a392f165d14b2fc3067636b4,
        INCREASE_REFCOUNT( Py_None ),
#if PYTHON_VERSION >= 300
        INCREASE_REFCOUNT( Py_None ),
        NULL,
#endif
        module___main__,
        Py_None
    );

    return result;
}



static PyObject *MAKE_FUNCTION_function_3_draw_of_class_1_SoftContext_of_module___main__(  )
{
    PyObject *result = Nuitka_Function_New(
        fparse_function_3_draw_of_class_1_SoftContext_of_module___main__,
        dparse_function_3_draw_of_class_1_SoftContext_of_module___main__,
        const_str_plain_draw,
#if PYTHON_VERSION >= 330
        NULL,
#endif
        codeobj_8667de4f175250243a986379632db040,
        INCREASE_REFCOUNT( Py_None ),
#if PYTHON_VERSION >= 300
        INCREASE_REFCOUNT( Py_None ),
        NULL,
#endif
        module___main__,
        Py_None
    );

    return result;
}



static PyObject *MAKE_FUNCTION_function_3_trans_of_module___main__(  )
{
    PyObject *result = Nuitka_Function_New(
        fparse_function_3_trans_of_module___main__,
        dparse_function_3_trans_of_module___main__,
        const_str_plain_trans,
#if PYTHON_VERSION >= 330
        NULL,
#endif
        codeobj_c4a1903f12bfa44d9a00f8fc685e76be,
        INCREASE_REFCOUNT( const_tuple_int_0_int_0_int_0_tuple ),
#if PYTHON_VERSION >= 300
        INCREASE_REFCOUNT( Py_None ),
        NULL,
#endif
        module___main__,
        Py_None
    );

    return result;
}



static PyObject *MAKE_FUNCTION_function_4_push_of_module___main__(  )
{
    PyObject *result = Nuitka_Function_New(
        fparse_function_4_push_of_module___main__,
        dparse_function_4_push_of_module___main__,
        const_str_plain_push,
#if PYTHON_VERSION >= 330
        NULL,
#endif
        codeobj_50e8ec0c7dd41646e9e953668d8ae96d,
        INCREASE_REFCOUNT( const_tuple_int_0_tuple ),
#if PYTHON_VERSION >= 300
        INCREASE_REFCOUNT( Py_None ),
        NULL,
#endif
        module___main__,
        Py_None
    );

    return result;
}



static PyObject *MAKE_FUNCTION_function_5_uvscroll_of_module___main__(  )
{
    PyObject *result = Nuitka_Function_New(
        fparse_function_5_uvscroll_of_module___main__,
        dparse_function_5_uvscroll_of_module___main__,
        const_str_plain_uvscroll,
#if PYTHON_VERSION >= 330
        NULL,
#endif
        codeobj_c512a3d9de996a802acc8413add02a81,
        INCREASE_REFCOUNT( const_tuple_int_0_int_0_tuple ),
#if PYTHON_VERSION >= 300
        INCREASE_REFCOUNT( Py_None ),
        NULL,
#endif
        module___main__,
        Py_None
    );

    return result;
}



static PyObject *MAKE_FUNCTION_function_6_scale_of_module___main__(  )
{
    PyObject *result = Nuitka_Function_New(
        fparse_function_6_scale_of_module___main__,
        dparse_function_6_scale_of_module___main__,
        const_str_plain_scale,
#if PYTHON_VERSION >= 330
        NULL,
#endif
        codeobj_749ebd4f18a30772c80835186ba8cb77,
        INCREASE_REFCOUNT( Py_None ),
#if PYTHON_VERSION >= 300
        INCREASE_REFCOUNT( Py_None ),
        NULL,
#endif
        module___main__,
        Py_None
    );

    return result;
}



static PyObject *MAKE_FUNCTION_function_7_draw_point_of_module___main__(  )
{
    PyObject *result = Nuitka_Function_New(
        fparse_function_7_draw_point_of_module___main__,
        dparse_function_7_draw_point_of_module___main__,
        const_str_plain_draw_point,
#if PYTHON_VERSION >= 330
        NULL,
#endif
        codeobj_06499d857bb5eb0c4455acb1cc08a735,
        INCREASE_REFCOUNT( Py_None ),
#if PYTHON_VERSION >= 300
        INCREASE_REFCOUNT( Py_None ),
        NULL,
#endif
        module___main__,
        Py_None
    );

    return result;
}



static PyObject *MAKE_FUNCTION_function_8_draw_tri_of_module___main__(  )
{
    PyObject *result = Nuitka_Function_New(
        fparse_function_8_draw_tri_of_module___main__,
        dparse_function_8_draw_tri_of_module___main__,
        const_str_plain_draw_tri,
#if PYTHON_VERSION >= 330
        NULL,
#endif
        codeobj_23d26e9a4357f26a48ab4b92efd93125,
        INCREASE_REFCOUNT( Py_None ),
#if PYTHON_VERSION >= 300
        INCREASE_REFCOUNT( Py_None ),
        NULL,
#endif
        module___main__,
        const_str_digest_94dfd43f8f874bcc545d53a56530a27c
    );

    return result;
}



static PyObject *MAKE_FUNCTION_function_9_draw_tri_split_of_module___main__(  )
{
    PyObject *result = Nuitka_Function_New(
        fparse_function_9_draw_tri_split_of_module___main__,
        dparse_function_9_draw_tri_split_of_module___main__,
        const_str_plain_draw_tri_split,
#if PYTHON_VERSION >= 330
        NULL,
#endif
        codeobj_58a571aae93f9586390ea067d684c052,
        INCREASE_REFCOUNT( Py_None ),
#if PYTHON_VERSION >= 300
        INCREASE_REFCOUNT( Py_None ),
        NULL,
#endif
        module___main__,
        const_str_digest_ad50deaf9e42f9e5edf282b279260b10
    );

    return result;
}



static PyObject *MAKE_FUNCTION_lambda_1_lambda_of_function_11_draw_tri_point_up_of_module___main__(  )
{
    PyObject *result = Nuitka_Function_New(
        fparse_lambda_1_lambda_of_function_11_draw_tri_point_up_of_module___main__,
        dparse_lambda_1_lambda_of_function_11_draw_tri_point_up_of_module___main__,
        const_str_angle_lambda,
#if PYTHON_VERSION >= 330
        NULL,
#endif
        codeobj_a7ab5a3207021c9d3e33271791acc28a,
        INCREASE_REFCOUNT( Py_None ),
#if PYTHON_VERSION >= 300
        INCREASE_REFCOUNT( Py_None ),
        NULL,
#endif
        module___main__,
        Py_None
    );

    return result;
}



static PyObject *MAKE_FUNCTION_lambda_1_lambda_of_function_3_draw_of_class_1_SoftContext_of_module___main__(  )
{
    PyObject *result = Nuitka_Function_New(
        fparse_lambda_1_lambda_of_function_3_draw_of_class_1_SoftContext_of_module___main__,
        dparse_lambda_1_lambda_of_function_3_draw_of_class_1_SoftContext_of_module___main__,
        const_str_angle_lambda,
#if PYTHON_VERSION >= 330
        NULL,
#endif
        codeobj_f679d2f49ece2d6f8edfb3d70295f3ef,
        INCREASE_REFCOUNT( Py_None ),
#if PYTHON_VERSION >= 300
        INCREASE_REFCOUNT( Py_None ),
        NULL,
#endif
        module___main__,
        Py_None
    );

    return result;
}



static PyObject *MAKE_FUNCTION_lambda_1_lambda_of_function_8_draw_tri_of_module___main__(  )
{
    PyObject *result = Nuitka_Function_New(
        fparse_lambda_1_lambda_of_function_8_draw_tri_of_module___main__,
        dparse_lambda_1_lambda_of_function_8_draw_tri_of_module___main__,
        const_str_angle_lambda,
#if PYTHON_VERSION >= 330
        NULL,
#endif
        codeobj_607cf003ee6a434a10ad254c191c3224,
        INCREASE_REFCOUNT( Py_None ),
#if PYTHON_VERSION >= 300
        INCREASE_REFCOUNT( Py_None ),
        NULL,
#endif
        module___main__,
        Py_None
    );

    return result;
}


#if PYTHON_VERSION >= 300
static struct PyModuleDef mdef___main__ =
{
    PyModuleDef_HEAD_INIT,
    "__main__",   /* m_name */
    NULL,                /* m_doc */
    -1,                  /* m_size */
    NULL,                /* m_methods */
    NULL,                /* m_reload */
    NULL,                /* m_traverse */
    NULL,                /* m_clear */
    NULL,                /* m_free */
  };
#endif

#define _MODULE_UNFREEZER 0

#if _MODULE_UNFREEZER

#include "nuitka/unfreezing.hpp"

// Table for lookup to find "frozen" modules or DLLs, i.e. the ones included in
// or along this binary.
static struct Nuitka_MetaPathBasedLoaderEntry meta_path_loader_entries[] =
{

    { NULL, NULL, 0 }
};

#endif

// The exported interface to CPython. On import of the module, this function
// gets called. It has to have an exact function name, in cases it's a shared
// library export. This is hidden behind the MOD_INIT_DECL.

MOD_INIT_DECL( __main__ )
{

#if defined(_NUITKA_EXE) || PYTHON_VERSION >= 300
    static bool _init_done = false;

    // Packages can be imported recursively in deep executables.
    if ( _init_done )
    {
        return MOD_RETURN_VALUE( module___main__ );
    }
    else
    {
        _init_done = true;
    }
#endif

#ifdef _NUITKA_MODULE
    // In case of a stand alone extension module, need to call initialization
    // the init here because that's the first and only time we are going to get
    // called here.

    // Initialize the constant values used.
    _initBuiltinModule();
    _initConstants();

    // Initialize the compiled types of Nuitka.
    PyType_Ready( &Nuitka_Generator_Type );
    PyType_Ready( &Nuitka_Function_Type );
    PyType_Ready( &Nuitka_Method_Type );
    PyType_Ready( &Nuitka_Frame_Type );
#if PYTHON_VERSION < 300
    initSlotCompare();
#endif

    patchBuiltinModule();
    patchTypeComparison();

#endif

#if _MODULE_UNFREEZER
    registerMetaPathBasedUnfreezer( meta_path_loader_entries );
#endif

    // puts( "in init__main__" );

    // Create the module object first. There are no methods initially, all are
    // added dynamically in actual code only.  Also no "__doc__" is initially
    // set at this time, as it could not contain NUL characters this way, they
    // are instead set in early module code.  No "self" for modules, we have no
    // use for it.
#if PYTHON_VERSION < 300
    module___main__ = Py_InitModule4(
        "__main__",       // Module Name
        NULL,                    // No methods initially, all are added
                                 // dynamically in actual module code only.
        NULL,                    // No __doc__ is initially set, as it could
                                 // not contain NUL this way, added early in
                                 // actual code.
        NULL,                    // No self for modules, we don't use it.
        PYTHON_API_VERSION
    );
#else
    module___main__ = PyModule_Create( &mdef___main__ );
#endif

    moduledict___main__ = (PyDictObject *)((PyModuleObject *)module___main__)->md_dict;

    assertObject( module___main__ );

// Seems to work for Python2.7 out of the box, but for Python3, the module
// doesn't automatically enter "sys.modules", so do it manually.
#if PYTHON_VERSION >= 300
    {
        int r = PyObject_SetItem( PySys_GetObject( (char *)"modules" ), const_str_plain___main__, module___main__ );

        assert( r != -1 );
    }
#endif

    // For deep importing of a module we need to have "__builtins__", so we set
    // it ourselves in the same way than CPython does. Note: This must be done
    // before the frame object is allocated, or else it may fail.

    PyObject *module_dict = PyModule_GetDict( module___main__ );

    if ( PyDict_GetItem( module_dict, const_str_plain___builtins__ ) == NULL )
    {
        PyObject *value = ( PyObject *)module_builtin;

#ifdef _NUITKA_EXE
        if ( module___main__ != module___main__ )
        {
#endif
            value = PyModule_GetDict( value );
#ifdef _NUITKA_EXE
        }
#endif

#ifndef __NUITKA_NO_ASSERT__
        int res =
#endif
            PyDict_SetItem( module_dict, const_str_plain___builtins__, value );

        assert( res == 0 );
    }

#if PYTHON_VERSION >= 330
#if _MODULE_UNFREEZER
    PyDict_SetItem( module_dict, const_str_plain___loader__, metapath_based_loader );
#else
    PyDict_SetItem( module_dict, const_str_plain___loader__, Py_None );
#endif
#endif

    // Temp variables if any
    PyObjectTempVariable tmp_tuple_unpack_1__source_iter;
    PyObjectTempVariable tmp_tuple_unpack_1__element_1;
    PyObjectTempVariable tmp_tuple_unpack_1__element_2;
    PyObjectTempVariable tmp_tuple_unpack_2__source_iter;
    PyObjectTempVariable tmp_tuple_unpack_2__element_1;
    PyObjectTempVariable tmp_tuple_unpack_2__element_2;

    // Module code
    PyFrameObject *frame_module___main__ = MAKE_FRAME( codeobj_7c329084be42df75341b2ddb92925123, module___main__ );

    FrameGuard frame_guard( frame_module___main__ );
    try
    {
        assert( Py_REFCNT( frame_module___main__ ) == 2 ); // Frame stack
        frame_guard.setLineNumber( 1 );
        DECREASE_REFCOUNT( IMPORT_MODULE( const_str_plain_site, ((PyModuleObject *)module___main__)->md_dict, ((PyModuleObject *)module___main__)->md_dict, const_tuple_empty, const_int_neg_1 ) );
        UPDATE_STRING_DICT0( moduledict___main__, (Nuitka_StringObject *)const_str_plain___doc__, Py_None );
        UPDATE_STRING_DICT0( moduledict___main__, (Nuitka_StringObject *)const_str_plain___file__, const_str_digest_7743a3f81638ef69dfcd906d6a6b0698 );
        UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_os, IMPORT_MODULE( const_str_plain_os, ((PyModuleObject *)module___main__)->md_dict, ((PyModuleObject *)module___main__)->md_dict, Py_None, const_int_neg_1 ) );
        frame_guard.setLineNumber( 2 );
        UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_pygame, IMPORT_MODULE( const_str_plain_pygame, ((PyModuleObject *)module___main__)->md_dict, ((PyModuleObject *)module___main__)->md_dict, Py_None, const_int_neg_1 ) );
        frame_guard.setLineNumber( 3 );
        UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_pygame, IMPORT_MODULE( const_str_digest_25e1d3d377df7c5a54fbd0fa6f18f2dc, ((PyModuleObject *)module___main__)->md_dict, ((PyModuleObject *)module___main__)->md_dict, Py_None, const_int_neg_1 ) );
        frame_guard.setLineNumber( 5 );
        UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_numpy, IMPORT_MODULE( const_str_plain_numpy, ((PyModuleObject *)module___main__)->md_dict, ((PyModuleObject *)module___main__)->md_dict, Py_None, const_int_neg_1 ) );
        frame_guard.setLineNumber( 6 );
        UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_math, IMPORT_MODULE( const_str_plain_math, ((PyModuleObject *)module___main__)->md_dict, ((PyModuleObject *)module___main__)->md_dict, Py_None, const_int_neg_1 ) );
        frame_guard.setLineNumber( 7 );
        UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_random, IMPORT_MODULE( const_str_plain_random, ((PyModuleObject *)module___main__)->md_dict, ((PyModuleObject *)module___main__)->md_dict, Py_None, const_int_neg_1 ) );
        frame_guard.setLineNumber( 12 );
        PythonExceptionKeeper _caught_1;
#if PYTHON_VERSION < 300
        int _at_lineno_1 = 0;
#endif


        try
        {
            // Tried block:
            tmp_tuple_unpack_1__source_iter.assign1( MAKE_ITERATOR( const_tuple_int_pos_192_int_pos_120_tuple ) );
            tmp_tuple_unpack_1__element_1.assign1( UNPACK_NEXT( tmp_tuple_unpack_1__source_iter.asObject0(), 0 ) );
            tmp_tuple_unpack_1__element_2.assign1( UNPACK_NEXT( tmp_tuple_unpack_1__source_iter.asObject0(), 1 ) );
            UNPACK_ITERATOR_CHECK( tmp_tuple_unpack_1__source_iter.asObject0(), 2 );
            UPDATE_STRING_DICT0( moduledict___main__, (Nuitka_StringObject *)const_str_plain_s_w, tmp_tuple_unpack_1__element_1.asObject0() );
            UPDATE_STRING_DICT0( moduledict___main__, (Nuitka_StringObject *)const_str_plain_s_h, tmp_tuple_unpack_1__element_2.asObject0() );
        }
        catch ( PythonException &_exception )
        {
#if PYTHON_VERSION >= 300
            if ( !_exception.hasTraceback() )
            {
                _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
            }
            else
            {
                _exception.addTraceback( frame_guard.getFrame0() );
            }
#else
            _at_lineno_1 = frame_guard.getLineNumber();
#endif

            _caught_1.save( _exception );

#if PYTHON_VERSION >= 300
            frame_guard.preserveExistingException();

            _exception.toExceptionHandler();
#endif
        }

        // Final block:
        tmp_tuple_unpack_1__source_iter.del( true );
        tmp_tuple_unpack_1__element_1.del( true );
        tmp_tuple_unpack_1__element_2.del( true );
#if PYTHON_VERSION < 300
        if ( _at_lineno_1 != 0 )
        {
           frame_guard.setLineNumber( _at_lineno_1 );
        }
#endif
        _caught_1.rethrow();
        // Final end
        frame_guard.setLineNumber( 13 );
        PythonExceptionKeeper _caught_2;
#if PYTHON_VERSION < 300
        int _at_lineno_2 = 0;
#endif


        try
        {
            // Tried block:
            tmp_tuple_unpack_2__source_iter.assign1( MAKE_ITERATOR( const_tuple_int_pos_256_int_pos_192_tuple ) );
            tmp_tuple_unpack_2__element_1.assign1( UNPACK_NEXT( tmp_tuple_unpack_2__source_iter.asObject0(), 0 ) );
            tmp_tuple_unpack_2__element_2.assign1( UNPACK_NEXT( tmp_tuple_unpack_2__source_iter.asObject0(), 1 ) );
            UNPACK_ITERATOR_CHECK( tmp_tuple_unpack_2__source_iter.asObject0(), 2 );
            UPDATE_STRING_DICT0( moduledict___main__, (Nuitka_StringObject *)const_str_plain_r_w, tmp_tuple_unpack_2__element_1.asObject0() );
            UPDATE_STRING_DICT0( moduledict___main__, (Nuitka_StringObject *)const_str_plain_r_h, tmp_tuple_unpack_2__element_2.asObject0() );
        }
        catch ( PythonException &_exception )
        {
#if PYTHON_VERSION >= 300
            if ( !_exception.hasTraceback() )
            {
                _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
            }
            else
            {
                _exception.addTraceback( frame_guard.getFrame0() );
            }
#else
            _at_lineno_2 = frame_guard.getLineNumber();
#endif

            _caught_2.save( _exception );

#if PYTHON_VERSION >= 300
            frame_guard.preserveExistingException();

            _exception.toExceptionHandler();
#endif
        }

        // Final block:
        tmp_tuple_unpack_2__source_iter.del( true );
        tmp_tuple_unpack_2__element_1.del( true );
        tmp_tuple_unpack_2__element_2.del( true );
#if PYTHON_VERSION < 300
        if ( _at_lineno_2 != 0 )
        {
           frame_guard.setLineNumber( _at_lineno_2 );
        }
#endif
        _caught_2.rethrow();
        // Final end
        frame_guard.setLineNumber( 14 );
        PyObject *_tmp_assign_unpack_1__assign_source;
        {
            PyObjectTempKeeper1 call1;
            PyObjectTempKeeper1 call2;
            PyObjectTempKeeper0 make_list1;
            _tmp_assign_unpack_1__assign_source = ( call1.assign( LOOKUP_ATTRIBUTE( PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_display ) ).asObject0(), const_str_plain_set_mode ) ), call2.assign( ( make_list1.assign( GET_MODULE_VALUE0( const_str_plain_r_w ) ), MAKE_LIST2( make_list1.asObject1(), GET_MODULE_VALUE1( const_str_plain_r_h ) ) ) ), CALL_FUNCTION_WITH_ARGS2( call1.asObject0(), call2.asObject0(), PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_DOUBLEBUF ) ).asObject0() ) );
        }
        PyObjectTemporaryWithDel tmp_assign_unpack_1__assign_source( _tmp_assign_unpack_1__assign_source );
        {
            PyObject *tmp_identifier = tmp_assign_unpack_1__assign_source.asObject0();
            SET_ATTRIBUTE( tmp_identifier, GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_screen );
        }
        UPDATE_STRING_DICT0( moduledict___main__, (Nuitka_StringObject *)const_str_plain_s, tmp_assign_unpack_1__assign_source.asObject0() );
        tmp_assign_unpack_1__assign_source.del( false );
        frame_guard.setLineNumber( 15 );
        UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_clock, CALL_FUNCTION_NO_ARGS( PyObjectTemporary( LOOKUP_ATTRIBUTE( PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_time ) ).asObject0(), const_str_plain_Clock ) ).asObject0() ) );
        frame_guard.setLineNumber( 17 );
        IMPORT_MODULE_STAR( module___main__, true, PyObjectTemporary( IMPORT_MODULE( const_str_plain_models, ((PyModuleObject *)module___main__)->md_dict, ((PyModuleObject *)module___main__)->md_dict, const_tuple_str_chr_42_tuple, const_int_neg_1 ) ).asObject0() );
        PyObject *tmp_class_creation_1__bases = const_tuple_empty;
        frame_guard.setLineNumber( 19 );
        PyObjectTemporaryWithDel tmp_class_creation_1__class_dict( impl_class_1_SoftContext_of_module___main__(  ) );
        PyObjectTemporaryWithDel tmp_class_creation_1__metaclass( ( SEQUENCE_CONTAINS_BOOL( const_str_plain___metaclass__, tmp_class_creation_1__class_dict.asObject0() ) ? DICT_GET_ITEM( tmp_class_creation_1__class_dict.asObject0(), const_str_plain___metaclass__ ) : SELECT_METACLASS( tmp_class_creation_1__bases, GET_STRING_DICT_VALUE( moduledict___main__, (Nuitka_StringObject *)const_str_plain___metaclass__ ) ) ) );
        PyObject *_tmp_class_creation_1__class;
        {
            PyObjectTempKeeper0 call1;
            PyObjectTempKeeper0 call2;
            _tmp_class_creation_1__class = ( call1.assign( tmp_class_creation_1__metaclass.asObject0() ), call2.assign( tmp_class_creation_1__bases ), CALL_FUNCTION_WITH_ARGS3( call1.asObject0(), const_str_plain_SoftContext, call2.asObject0(), tmp_class_creation_1__class_dict.asObject0() ) );
        }
        PyObjectTemporaryWithDel tmp_class_creation_1__class( _tmp_class_creation_1__class );
        tmp_class_creation_1__bases = NULL;
        tmp_class_creation_1__class_dict.del( false );
        tmp_class_creation_1__metaclass.del( false );
        UPDATE_STRING_DICT0( moduledict___main__, (Nuitka_StringObject *)const_str_plain_SoftContext, tmp_class_creation_1__class.asObject0() );
        tmp_class_creation_1__class.del( false );
        frame_guard.setLineNumber( 53 );
        {
            PyObjectTempKeeper0 call1;
            PyObjectTempKeeper0 call2;
            UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_softcontext, ( call1.assign( GET_MODULE_VALUE0( const_str_plain_SoftContext ) ), call2.assign( GET_MODULE_VALUE0( const_str_plain_s_w ) ), CALL_FUNCTION_WITH_ARGS4( call1.asObject0(), call2.asObject0(), GET_MODULE_VALUE0( const_str_plain_s_h ), const_int_pos_192, const_int_pos_120 ) ) );
        }
        frame_guard.setLineNumber( 55 );
        UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_bg1, CALL_FUNCTION_WITH_ARGS1( PyObjectTemporary( LOOKUP_ATTRIBUTE( PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_image ) ).asObject0(), const_str_plain_load ) ).asObject0(), const_str_digest_7dd812759f35b7a572f577e55a33bb29 ) );
        frame_guard.setLineNumber( 56 );
        UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_bg2, CALL_FUNCTION_WITH_ARGS1( PyObjectTemporary( LOOKUP_ATTRIBUTE( PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_pygame ), const_str_plain_image ) ).asObject0(), const_str_plain_load ) ).asObject0(), const_str_digest_bbae2702589dd5a0f101df8e4618e350 ) );
        frame_guard.setLineNumber( 57 );
        DECREASE_REFCOUNT( CALL_FUNCTION_WITH_ARGS1( PyObjectTemporary( LOOKUP_ATTRIBUTE( GET_MODULE_VALUE0( const_str_plain_bg2 ), const_str_plain_set_colorkey ) ).asObject0(), PyObjectTemporary( LIST_COPY( const_list_int_pos_255_int_0_int_pos_255_list ) ).asObject0() ) );
        UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_load_tex, MAKE_FUNCTION_function_2_load_tex_of_module___main__(  ) );
        UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_trans, MAKE_FUNCTION_function_3_trans_of_module___main__(  ) );
        UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_push, MAKE_FUNCTION_function_4_push_of_module___main__(  ) );
        UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_uvscroll, MAKE_FUNCTION_function_5_uvscroll_of_module___main__(  ) );
        UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_scale, MAKE_FUNCTION_function_6_scale_of_module___main__(  ) );
        UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_draw_point, MAKE_FUNCTION_function_7_draw_point_of_module___main__(  ) );
        UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_draw_tri, MAKE_FUNCTION_function_8_draw_tri_of_module___main__(  ) );
        UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_draw_tri_split, MAKE_FUNCTION_function_9_draw_tri_split_of_module___main__(  ) );
        UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_draw_line, MAKE_FUNCTION_function_10_draw_line_of_module___main__(  ) );
        UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_draw_tri_point_up, MAKE_FUNCTION_function_11_draw_tri_point_up_of_module___main__(  ) );
        UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_draw_tri_point_down, MAKE_FUNCTION_function_12_draw_tri_point_down_of_module___main__(  ) );
        UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_draw_quad, MAKE_FUNCTION_function_13_draw_quad_of_module___main__(  ) );
        UPDATE_STRING_DICT1( moduledict___main__, (Nuitka_StringObject *)const_str_plain_main, MAKE_FUNCTION_function_14_main_of_module___main__(  ) );
        frame_guard.setLineNumber( 331 );
        DECREASE_REFCOUNT( CALL_FUNCTION_NO_ARGS( GET_MODULE_VALUE0( const_str_plain_main ) ) );
    }
    catch ( PythonException &_exception )
    {
        if ( !_exception.hasTraceback() )
        {
            _exception.setTraceback( MAKE_TRACEBACK( frame_guard.getFrame() ) );
        }
        else
        {
            _exception.addTraceback( frame_guard.getFrame0() );
        }

#if 0
    // TODO: Recognize the need for it
        Py_XDECREF( frame_guard.getFrame0()->f_locals );
        frame_guard.getFrame0()->f_locals = INCREASE_REFCOUNT( ((PyModuleObject *)module___main__)->md_dict );
#endif

        // Return the error.
        _exception.toPython();
        return MOD_RETURN_VALUE( NULL );
    }

   return MOD_RETURN_VALUE( module___main__ );
}
// The main program for C++. It needs to prepare the interpreter and then
// calls the initialization code of the __main__ module.

#include "structseq.h"
#ifdef _NUITKA_WINMAIN_ENTRY_POINT
int __stdcall WinMain( HINSTANCE hInstance, HINSTANCE hPrevInstance, char* lpCmdLine, int nCmdShow )
{
    int argc = __argc;
    char** argv = __argv;
#else
int main( int argc, char *argv[] )
{
#endif
#ifdef _NUITKA_STANDALONE
    prepareStandaloneEnvironment();
#endif

    // Initialize Python environment.
    Py_DebugFlag = 0;
#if 0
    Py_Py3kWarningFlag = 0;
#endif
#if 0
    Py_DivisionWarningFlag =
#if 0
        Py_Py3kWarningFlag ||
#endif
        0;
#endif
    Py_InspectFlag = 0;
    Py_InteractiveFlag = 0;
    Py_OptimizeFlag = 0;
    Py_DontWriteBytecodeFlag = 0;
    Py_NoUserSiteDirectory = 0;
    Py_IgnoreEnvironmentFlag = 0;
#if 0
    Py_TabcheckFlag = 0;
#endif
    Py_VerboseFlag = 0;
#if 0
    Py_UnicodeFlag = 0;
#endif
    Py_BytesWarningFlag = 0;
#if 1
    Py_HashRandomizationFlag = 1;
#endif

    // We want to import the site module, but only after we finished our own
    // setup. The site module import will be the first thing, the main module
    // does.
    Py_NoSiteFlag = 1;

    // Initialize the embedded CPython interpreter.
    setCommandLineParameters( argc, argv, true );
    Py_Initialize();

    // Lie about it, believe it or not, there are "site" files, that check
    // against later imports, see below.
    Py_NoSiteFlag = 0;

    // Set the command line parameters for run time usage.
    setCommandLineParameters( argc, argv, false );

    // Initialize the constant values used.
    _initBuiltinModule();
    _initConstants();
    _initBuiltinOriginalValues();

    // Revert the wrong sys.flags value, it's used by "site" on at least Debian
    // for Python3.3, more uses may exist.
#if 0 == 0
#if PYTHON_VERSION >= 330
    PyStructSequence_SetItem( PySys_GetObject( "flags" ), 6, const_int_0 );
#elif PYTHON_VERSION >= 320
    PyStructSequence_SetItem( PySys_GetObject( "flags" ), 7, const_int_0 );
#elif PYTHON_VERSION >= 260
    PyStructSequence_SET_ITEM( PySys_GetObject( (char *)"flags" ), 9, const_int_0 );
#endif
#endif

    // Initialize the compiled types of Nuitka.
    PyType_Ready( &Nuitka_Generator_Type );
    PyType_Ready( &Nuitka_Function_Type );
    PyType_Ready( &Nuitka_Method_Type );
    PyType_Ready( &Nuitka_Frame_Type );
#if PYTHON_VERSION < 300
    initSlotCompare();
#endif

    enhancePythonTypes();

    // Set the sys.executable path to the original Python executable on Linux
    // or to python.exe on Windows.
    PySys_SetObject(
        (char *)"executable",
        const_str_digest_c42384e11d8039023cc63f738682e4b1
    );

    patchBuiltinModule();
    patchTypeComparison();

    // Allow to override the ticker value, to remove checks for threads in
    // CPython core from impact on benchmarks.
    char const *ticker_value = getenv( "NUITKA_TICKER" );
    if ( ticker_value != NULL )
    {
        _Py_Ticker = atoi( ticker_value );
        assert ( _Py_Ticker >= 20 );
    }

#if _NUITKA_STANDALONE
    setEarlyFrozenModulesFileAttribute();
#endif

    // Execute the "__main__" module init function.
    MOD_INIT_NAME( __main__ )();

    if ( ERROR_OCCURED() )
    {
        // Cleanup code may need a frame, so put one back.
        PyThreadState_GET()->frame = MAKE_FRAME( codeobj_7c329084be42df75341b2ddb92925123, module___main__ );

        PyErr_PrintEx( 0 );
        Py_Exit( 1 );
    }
    else
    {
        Py_Exit( 0 );
    }
}
