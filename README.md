# basi/varnish3
It installs Varnish 3 using CentOS 6 as a host OS.

### Varnish
It allows you to use an specific VCL file when you provide an environment variable named: `$VCL_CONFIG`. But
you can provide a directory instead of a file and the system internally will merge all the "vcl" files found in
the directory to create the VCL file that will be used by Varnish.

This approach is useful when you have complicated Varnish logic, and it allows to use small consul-template templates.

As the provided VCL is split in pieces you can overwrite each piece individually in your container or the entire
directory.

## Example of use

### Provide a directory with the logic split in files

You can override in your image or container the provided template by something like this:

You can launch it as:

    docker run --rm -it -P \
        -v $PWD/:/etc/varnish/conf.d/ \
        -e VCL_CONFIG=/etc/varnish/conf.d \
        basi/varnish3

It will use the VCL files contained in the volume instead of the originally available files provided by the image.
If you want to change one VCL status you just need to to it with:

    docker run --rm -it -P \
        -v $PWD/rootfs/etc/varnish/conf.d/30-vcl_deliver.vcl:/etc/varnish/conf.d/30-vcl_deliver.vcl \
        -e VCL_CONFIG=/etc/varnish/conf.d \
        basi/varnish3

And it will just switch just the logic executed in the vcl_deliver status by yours.

### Usage for testing VCL logic

It has "varnishtest" tool integrated, then you can use it to test your VCL logic using it. For example:

```
docker run --rm -it -P \
  -v $PWD/src:/etc/varnish/conf.d/ \
  -v $PWD/tests:/etc/varnish/tests/ \
  basi/varnish3 varnishtest -D include_path=/etc/varnish/conf.d /etc/varnish/tests/*.vtc  
```

docker run -d -it -P --name varnish3 \
  -v $PWD/src:/etc/varnish/conf.d/ \
  -v $PWD/tests:/etc/varnish/tests/ \
  basi/varnish3 sleep 1000 

### Other supported parameters:

`$CACHE_SIZE`:      Determines the cache size used by varnish
`$VARNISHD_PARAMS`: Other parameters you want to pass to the varnish daemon
`$VARNISH_PARAM_*`: Any environment variable with this prefix can be used to substitute its value in a VCL with a placeholder with the same name.
  For example if your VCL contains something like: `.host = "#VARNISH_PARAM_SERVICE#";` and you have an environment variable like `VARNISH_PARAM_SERVICE=my_svc`
  you'll end up with `.host = "my_svc";`
