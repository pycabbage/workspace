# workspace

使い捨て作業環境

## Development

```shell
docker bake --progress=plain --set default.tags=workspace:latest && docker run --group-add 1001 -it --rm -e TERM -e LANG -v /var/run/docker.sock:/var/run/docker.sock workspace
```
