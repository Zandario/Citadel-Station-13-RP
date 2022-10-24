#define DECL_TYPE_IS_ABSTRACT(DECL) (initial(DECL.abstract_type) == DECL)
#define DECL_INSTANCE_IS_ABSTRACT(DECL) (DECL.abstract_type == DECL.type)
