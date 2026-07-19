# Adapters

Drop replacement `identity.pl` files here to remap the harness to any AI model.

## Convention

Each adapter is a self-contained `identity.pl` with:
- `persona/1` — model name
- `status/1` — active | suspended | sandboxed
- `governing_principle/1` — one or more trust axioms
- `prohibited_action/1` — hard constraints
- `competency/1` — domain capabilities

## Examples

| File | Persona |
|------|---------|
| `claude.pl` | Claude (default) |
| `bob.pl` | BOB sovereign runtime |
| `forge.pl` | FORGE code agent |
| `carto.pl` | CARTO spatial agent |

Copy any adapter over `core/identity.pl` and reload the harness.
