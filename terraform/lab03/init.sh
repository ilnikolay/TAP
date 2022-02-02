# Vars
backend_prefix="tap"
common_backend_vars_file="aws.s3.tfbackend"
backend_key_file="backend_key.tfbackend"
tf_cache_dir=$HOME/.terraform.d/plugin-cache
cur_dir="$PWD"

# Generate backend key
# Get the full directory structure excluding any numbers and trailing underscores
cur_dir_key=$(basename $PWD | cut -f2-9 -d'_')
backend_key="$backend_prefix/$cur_dir_key/terraform.tfstate"
echo key=\"$backend_key\" > $backend_key_file

# Set proper sed based on OS
case "$(uname -s)" in
   "Darwin") sed_cmd="gsed";; 
   "Linux" ) sed_cmd="sed";;
   "*"     ) echo "OS Not supported"; exit 1 ;;
esac

# Init global tf provider cache dir. TBD Handle Windows
export TF_PLUGIN_CACHE_DIR=$tf_cache_dir; mkdir -p $tf_cache_dir

terraform init --backend-config=$backend_key_file --backend-config=$common_backend_vars_file