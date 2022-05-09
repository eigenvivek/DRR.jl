export read_dicom

using DICOM
using PaddedViews

function read_dicom(path::String)

    dcm_data_array = dcmdir_parse(path)

    # Get the dimensions of the volume
    n_dcm = length(dcm_data_array)
    nx, ny = size(dcm_data_array[1][tag"PixelData"])
    volume = Array{Int16}(undef, (nx, ny, n_dcm))

    # Get the x- and y-directional voxel spacing 
    ΔX, ΔY = dcm_data_array[1][tag"PixelSpacing"]

    # Find the moving axis
    firstCoord = dcm_data_array[n_dcm][tag"ImagePositionPatient"]
    secondCoord = dcm_data_array[n_dcm-1][tag"ImagePositionPatient"]
    gapAxis = findall(x -> x == 0, firstCoord .≈ secondCoord)[1]

    gapCoords = Array{Float64}(undef, n_dcm)
    ΔZ = Array{Float64}(undef, n_dcm - 1)

    # Read the first slice of volume 
    slice = dcm_data_array[end][tag"PixelData"][end:-1:1, :]
    volume[:, :, 1] = slice
    gapCoords[1] = dcm_data_array[end][tag"ImagePositionPatient"][gapAxis]

    # Create the volume
    for i in 2:n_dcm
        # A little slice reordering is necessary to get this looking right
        slice = dcm_data_array[end-i+1][tag"PixelData"][end:-1:1, :]
        volume[:, :, i] = slice

        # find z spacing
        gapCoords[i] = dcm_data_array[end-i+1][tag"ImagePositionPatient"][gapAxis]
        ΔZ[i-1] = gapCoords[i] - gapCoords[i-1]

    end

    # Check if the z-directional spacing is constant
    if all(x ≈ ΔZ[1] for x in ΔZ)
        ΔZ = ΔZ[1]
    end

    padVol = PaddedViews.PaddedView(minimum(volume[:,:,1]), volume, (1:(nx+2),1:(ny+2), 1:(n_dcm+2)), (2:(ny+1),2:(ny+1),2:(n_dcm+1)))

    return padVol, ΔX, ΔY, ΔZ

end