/* -*-comment-start: "//";comment-end:""-*-
 * GNU Mes --- Maxwell Equations of Software
 * Copyright © 2018,2019,2022 Jan (janneke) Nieuwenhuizen <janneke@gnu.org>
 * Copyright © 2022 Timothy Sample <samplet@ngyro.com>
 *
 * This file is part of GNU Mes.
 *
 * GNU Mes is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or (at
 * your option) any later version.
 *
 * GNU Mes is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with GNU Mes.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "mes/lib.h"
#include "mes/mes.h"

struct scm *
make_initial_module (struct scm *a)     /*:((internal)) */
{
  struct scm *var;
  struct scm *module = make_hash_table_ (100);
  while (a->type == TPAIR)
    {
      var = make_variable (a->car->cdr);
      hashq_set_x (module, a->car->car, var);
      a = a->cdr;
    }
  return module;
}

struct scm *
initial_module ()
{
  return M0;
}

struct scm *
current_module ()
{
  if (M1 == cell_f)
    return initial_module ();
  else
    return M1;
}

struct scm *
set_current_module (struct scm *module)
{
  struct scm *previous = M1;
  M1 = module;
  return previous;
}

struct scm *
module_local_variable (struct scm *module, struct scm *name)
{
  struct scm *obarray = module;
  if (module != initial_module ())
    obarray = struct_ref_ (module, MODULE_OBARRAY);
  /* TODO: call binders maybe or never support them :) */
  return hashq_ref_ (obarray, name, cell_f);
}

struct scm *
module_ensure_local_variable_x (struct scm *module, struct scm *name)
{
  /* Ensure that there is a local variable in MODULE for SYMBOL.  If
   * there is no binding for SYMBOL, create a new uninitialized
   * variable.  Return the local variable.
   */
  struct scm *var = module_local_variable (module, name);
  if (var != cell_f)
    return var;

  struct scm *obarray = module;
  if (module != initial_module ())
    obarray = struct_ref_ (module, MODULE_OBARRAY);
  var = make_variable (cell_undefined);
  struct scm *handle = hashq_create_handle_x (obarray, name, var);

  /* TODO: Call 'module-modified' to invoke obervers, but only if there
     are observers, since we are trying to avoid Scheme code. */

  return handle->cdr;
}

struct scm *
module_variable (struct scm *module, struct scm *name)
{
  struct scm *modules = cons (module, cell_nil);
  struct scm *obarray;
  struct scm *variable;
  struct scm *uses;
  while (modules->type == TPAIR)
    {
      module = modules->car;
      variable = module_local_variable (module, name);
      if (variable != cell_f)
          return variable;

      if (module == initial_module ())
        break;

      /* TODO: Call binders. */
      uses = struct_ref_ (module, MODULE_USES);
      modules = append2 (uses, modules->cdr);
    }
  return cell_f;
}
