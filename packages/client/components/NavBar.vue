<script setup lang="ts">
import { formatDistance } from 'date-fns'
import { basePath, isDark, isOffline, isRescanSiteRequestRunning, isStatic, rescanSite, scanMeta, toggleDark, website } from '../logic'

const timeRemaining = computed(() => {
  return formatDistance(0, scanMeta.value.monitor.timeRemaining, { includeSeconds: true })
})

const favIcon = computed(() => {
  if (!scanMeta.value?.favicon)
    return '/favicon.ico'
  else if (scanMeta.value?.favicon?.startsWith('http'))
    return scanMeta.value?.favicon

  return website + (scanMeta.value?.favicon)
})
</script>

<template>
  <nav class="bg-white dark:(bg-transparent) font-light border-b border-main flex items-center gap-4 children:my-auto px-3 md:px-6 py-2 ">
    <a class="text-md font-medium text-teal-700 dark:text-teal-200 font-mono items-center hidden md:flex" href="https://app.nobreakweb.com" target="_blank">
      NoBreakWeb
    </a>
    <div class="flex w-full justify-between items-center text-xs md:ml-5 md:mr-10">
      <div class="flex items-center">
        <div v-if="website && !website.includes('localhost')" class="mr-5 hidden xl:block">
          <div class="uppercase opacity-55 ">
            Website
          </div>
          <div class="text-sm flex items-center">
            <a :href="website" class="flex items-center pt-1" target="_blank">
              <img :src="favIcon" width="16" height="16" class="mr-1">{{ website.replace('https://', '').replace('http://', '').replace('www.', '') }}
            </a>
          </div>
        </div>
        <div v-if="isOffline" class="mr-5 hidden md:block">
          <warning-chip>
            {{ isStatic ? 'Static' : 'Offline' }} Mode
          </warning-chip>
        </div>
        <div v-if="scanMeta" class="mr-5 hidden md:block">
          <div class="uppercase opacity-55">
            Total Score
          </div>
          <div class="flex items-center">
            <metric-guage v-if="scanMeta?.score" :score="scanMeta.score" :stripped="true" class="font-bold text-sm" />
            <loading-spinner v-else class="h-24px" />
          </div>
        </div>
      </div>
      <div v-if="scanMeta?.monitor?.allTargets > 0" class="flex flex-grow justify-around md:mr-5">
        <search-box class="flex-grow mr-3 md:mr-5" />
        <popover-actions v-slot="{ close }" position="bottom">
          <div class="w-225px flex flex-col">
            <btn-basic
              :disabled="isRescanSiteRequestRunning || isStatic || isOffline ? 'disabled' : false"
              class="flex items-start hover:bg-blue-500 transition children:hover:text-white"
              @click="rescanSite(close)"
            >
              <div style="flex-basis: 70px;" class="mt-1 text-blue-500">
                <i-mdi-magnify-scan class="text-xl" :class="isRescanSiteRequestRunning ? ['animated animate-pulse '] : []" />
              </div>
              <div class="text-left">
                <p class="break-none text-base">
                  Rescan Site
                </p>
                <span class="opacity-70 text-xs">
                  Crawl the site again and generate fresh new reports.
                </span>
              </div>
            </btn-basic>
          </div>
        </popover-actions>
      </div>
      <div v-if="!isOffline && scanMeta?.monitor" class="hidden xl:flex">
        <div class="mr-6">
          <div class="uppercase opacity-55 ">
            Worker Progress
          </div>
          <div class=" flex items-center">
            <span class="text-sm mr-1 font-bold">
              {{ scanMeta.monitor.donePercStr }}% <span class="text-xs opacity-60">{{
                scanMeta.monitor.doneTargets
              }}/{{ scanMeta.monitor.allTargets }}</span></span>
          </div>
        </div>
        <div class="mr-6 hidden 2xl:block">
          <div class="uppercase opacity-55">
            Time Remaining
          </div>
          <span class="text-sm">{{ scanMeta.monitor.status === 'completed' ? '-' : timeRemaining }}</span>
        </div>
        <div class="mr-6 hidden 2xl:block">
          <div class="uppercase opacity-55">
            CPU
          </div>
          <span class="text-sm">{{ scanMeta.monitor.status === 'completed' ? '-' : scanMeta.monitor.cpuUsage }}</span>
        </div>
      </div>
    </div>
    <div class="hidden md:flex-auto" />
    <btn-icon
      class="icon-btn text-lg"
      href="https://github.com/harlan-zw/unlighthouse"
      target="_blank"
    >
      <i-carbon-logo-github />
    </btn-icon>
    <btn-icon class="text-lg" title="Toggle Dark Mode" @click="toggleDark()">
      <i-carbon-moon v-if="isDark" />
      <i-carbon-sun v-else />
    </btn-icon>
  </nav>
</template>
