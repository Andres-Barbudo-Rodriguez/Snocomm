import Foundation

func convertInteger() {
    let data: UInt32 = 1234
    

    let hostToNetwork32 = data.bigEndian
    let networkToHost32 = data.littleEndian
    
    print("Original: \(data) => Long host byte order: \(networkToHost32), Network byte order: \(hostToNetwork32)")
    
    // Convert 16-bit integer
    let data16: UInt16 = UInt16(data & 0xFFFF)
    let hostToNetwork16 = data16.bigEndian
    let networkToHost16 = data16.littleEndian
    
    print("Original: \(data16) => Short host byte order: \(networkToHost16), Network byte order: \(hostToNetwork16)")
}

convertInteger()
