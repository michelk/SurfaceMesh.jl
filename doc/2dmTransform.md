---
title: Exectuable 2dmTransform
---

Transforming nodes of 2dm-mesh.

**Usage**

```bash
./bin/2dmTransform -h
```

    usage: 2dmTransform [--transX TRANSX] [--transY TRANSY]
                        [--transZ TRANSZ] [--scale SCALE] [-h] [mesh-file]

    Transform a 2dm-mesh: translation, scaling:

    positional arguments:
      mesh-file        mesh (2dm)-file

    optional arguments:
      --transX TRANSX  Translation in x (type: FloatingPoint, default:
                       0.0)
      --transY TRANSY  Translation in x (type: FloatingPoint, default:
                       0.0)
      --transZ TRANSZ  Translation in x (type: FloatingPoint, default:
                       0.0)
      --scale SCALE    Scaling factor (type: FloatingPoint, default: 1.0)
      -h, --help       show this help message and exit

Results are printed to `stdout`. Hence redirection is necassary; eg: 

    2dmTransform --transX 49237 --transY 28385 < mesh.2md > mesh_trans.2dm

    
