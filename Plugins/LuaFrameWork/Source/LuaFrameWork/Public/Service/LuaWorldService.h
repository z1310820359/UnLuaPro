// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Subsystems/WorldSubsystem.h"
#include "UnLuaInterface.h"
#include "Blueprint/UserWidget.h"
#include "UnLuaEx.h"
#include "LuaWorldService.generated.h"

/**
 * 
 */
UCLASS()
class LUAFRAMEWORK_API ULuaWorldService : public UWorldSubsystem, public IUnLuaInterface
{
	GENERATED_BODY()
public:
	virtual FString GetModuleName_Implementation() const override
	{
		return TEXT("Plugin.LuaFrameWork.Service.WorldService");
	}
	virtual bool ShouldCreateSubsystem(UObject* Outer) const override;
	virtual void Initialize(FSubsystemCollectionBase& Collection) override;
	virtual void PostInitialize() override;
	virtual void OnWorldBeginPlay(UWorld& InWorld) override;
	virtual void Deinitialize() override;

	UFUNCTION(BlueprintImplementableEvent)
	void LuaInit();

	UFUNCTION(BlueprintImplementableEvent)
	void LuaPostInit();

	UFUNCTION(BlueprintImplementableEvent)
	void LuaOnWorldBeginPlay();

	UFUNCTION(BlueprintImplementableEvent)
	void LuaDeinit();

	UFUNCTION()
	UUserWidget* GetWidgetByPath(FString Path);

	//UFUNCTION()
	//ULevelStreamingDynamic* LoadLevelByPath(FString Path, FVector Pos, FRotator Rotator);
};
