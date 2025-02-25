import { describe, it, beforeEach, expect } from "vitest"

describe("Entanglement Pair Contract", () => {
  let mockStorage: Map<string, any>
  let nextPairId: number
  
  beforeEach(() => {
    mockStorage = new Map()
    nextPairId = 0
  })
  
  const mockContractCall = (method: string, args: any[] = []) => {
    switch (method) {
      case "create-entangled-pair":
        const [particle1, particle2] = args
        nextPairId++
        mockStorage.set(`pair-${nextPairId}`, { particle1, particle2, state: "superposition" })
        return { success: true, value: nextPairId }
      case "measure-particle":
        const [pairId, particle] = args
        const pair = mockStorage.get(`pair-${pairId}`)
        if (!pair) return { success: false, error: 404 }
        if (pair.particle1 !== particle && pair.particle2 !== particle) return { success: false, error: 403 }
        pair.state = "measured"
        return { success: true }
      case "get-entangled-pair":
        return { success: true, value: mockStorage.get(`pair-${args[0]}`) }
      default:
        return { success: false, error: "Unknown method" }
    }
  }
  
  it("should create an entangled pair", () => {
    const result = mockContractCall("create-entangled-pair", ["particle1", "particle2"])
    expect(result.success).toBe(true)
    expect(result.value).toBe(1)
  })
  
  it("should measure a particle", () => {
    mockContractCall("create-entangled-pair", ["particle1", "particle2"])
    const result = mockContractCall("measure-particle", [1, "particle1"])
    expect(result.success).toBe(true)
  })
  
  it("should get an entangled pair", () => {
    mockContractCall("create-entangled-pair", ["particle1", "particle2"])
    const result = mockContractCall("get-entangled-pair", [1])
    expect(result.success).toBe(true)
    expect(result.value).toEqual({ particle1: "particle1", particle2: "particle2", state: "superposition" })
  })
})

